using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using FinancIA.Core.Application.Contracts.Repositories;
using FinancIA.Core.Application.Contracts.Services;
using FinancIA.Core.Application.Dtos.Auth;
using FinancIA.Core.Domain.Entities;
using FinancIA.Core.Domain.Settings;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace FinancIA.Core.Application.Services;

public class JwtService : IJwtService
{
    private readonly JwtSettings _jwtSettings;
    private readonly IGenericRepository<RefreshToken> _refreshTokenRepository;
    public JwtService(IOptions<JwtSettings> jwtSettings, IGenericRepository<RefreshToken> refreshTokenRepository)
    {
        _jwtSettings = jwtSettings.Value;
        _jwtSettings.KeyBytes = Encoding.UTF8.GetBytes(_jwtSettings.Key);
        _refreshTokenRepository = refreshTokenRepository;
    }
    public string GenerateAccessToken(IEnumerable<Claim> claims)
    {
        JwtSecurityTokenHandler tokenHandler = new JwtSecurityTokenHandler();
        SigningCredentials credentials = new SigningCredentials(new SymmetricSecurityKey(_jwtSettings.KeyBytes), SecurityAlgorithms.HmacSha256);

        SecurityTokenDescriptor tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Expires = DateTime.UtcNow.AddMinutes(_jwtSettings.AccessTokenExpirationTimeInMinutes),
            Issuer = _jwtSettings.Issuer,
            Audience = _jwtSettings.Audience,
            IssuedAt = DateTime.UtcNow,
            NotBefore = DateTime.UtcNow,
            SigningCredentials = credentials
        };

        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }

    public string GenerateRefreshToken()
    {
        byte[] randomBytes = RandomNumberGenerator.GetBytes(64);
        return Convert.ToBase64String(randomBytes);
    }

    public async Task<SystemTokens> GenerateTokens(Guid userId, Claim[] claims)
    {
        JwtSecurityToken jwtSecurityToken = new JwtSecurityToken(
            issuer: _jwtSettings.Issuer,
            audience: _jwtSettings.Audience,
            claims: claims,
            notBefore: DateTime.UtcNow,
            expires: DateTime.UtcNow.AddMinutes(_jwtSettings.AccessTokenExpirationTimeInMinutes),
            signingCredentials: new SigningCredentials(new SymmetricSecurityKey(_jwtSettings.KeyBytes), SecurityAlgorithms.HmacSha256)
        );

        string accessToken = new JwtSecurityTokenHandler().WriteToken(jwtSecurityToken);
        RefreshToken refreshToken = new RefreshToken
        {
            UserId = userId,
            Token = GenerateRefreshToken(),
            Created = DateTime.UtcNow,
            Expires = DateTime.UtcNow.AddMinutes(_jwtSettings.RefreshTokenExpirationTimeInMinutes),
        };

        RefreshToken? refreshTokenFromDb = await _refreshTokenRepository.GetBySpec(t => t.UserId == userId);
        if (refreshTokenFromDb is not null)
        {
            bool successRemovingOldToken = await _refreshTokenRepository.DeleteAsync(refreshTokenFromDb);
            if (!successRemovingOldToken) throw new InvalidOperationException("Algo salió mal");

        }

        refreshToken = await _refreshTokenRepository.SaveAsync(refreshToken);
        return new SystemTokens
        {
            AccessToken = accessToken,
            RefreshToken = refreshToken.Token
        };
    }

    public ClaimsPrincipal GetPrincipalFromExpiredToken(string token)
    {
        TokenValidationParameters tokenValidationParameters = new TokenValidationParameters
        {
            ValidateAudience = false,
            ValidateIssuer = false,
            ValidAudience = _jwtSettings.Audience,
            ValidIssuer = _jwtSettings.Issuer,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(_jwtSettings.KeyBytes),
            ValidateLifetime = false
        };

        JwtSecurityTokenHandler tokenHandler = new JwtSecurityTokenHandler();
        ClaimsPrincipal principal = tokenHandler.ValidateToken(token, tokenValidationParameters, out SecurityToken securityToken);
        if (securityToken is not JwtSecurityToken jwtToken ||
            !jwtToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase))
        {
            throw new SecurityTokenException("Invalid token");
        }

        return principal;

    }

    public async Task<bool> HasValidRefreshToken(Guid userId)
    {
        return await _refreshTokenRepository.AnyAsync(t => t.UserId == userId && t.Expires > DateTime.UtcNow);
    }
    public async Task<bool> CheckUserToken(Guid userId, string refreshToken)
    {
        return await _refreshTokenRepository.AnyAsync(t => t.UserId == userId && t.Expires > DateTime.UtcNow && t.Token == refreshToken);
    }

    public async Task<SystemTokens> Refresh(string refreshToken, string accessToken)
    {
        ClaimsPrincipal? principal = GetPrincipalFromExpiredToken(accessToken);

        JwtSecurityTokenHandler handler = new JwtSecurityTokenHandler();
        JwtSecurityToken expiredToken = handler.ReadJwtToken(accessToken);
        string userIdString = expiredToken.Claims.FirstOrDefault(cl => cl.Type == JwtRegisteredClaimNames.Sub)!.Value;

        Guid userId = Guid.Parse(userIdString);
        RefreshToken? refreshTokenFromDb = await _refreshTokenRepository.GetBySpec(t => t.UserId == userId);

        if (refreshTokenFromDb is null) throw new SecurityTokenException("Token inválido");

        return await GenerateTokens(userId, principal.Claims.ToArray());
    }
}
