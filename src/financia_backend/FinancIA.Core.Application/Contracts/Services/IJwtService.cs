using System.Security.Claims;
using FinancIA.Core.Application.Dtos.Auth;

namespace FinancIA.Core.Application.Contracts.Services;

public interface IJwtService
{
    string GenerateAccessToken(IEnumerable<Claim> claims);
    string GenerateRefreshToken();
    Task<SystemTokens> GenerateTokens(Guid userId, Claim[] claims);
    ClaimsPrincipal GetPrincipalFromExpiredToken(string token);
    Task<bool> HasValidRefreshToken(Guid userId);
    Task<bool> CheckUserToken(Guid userId, string refreshToken);
    Task<SystemTokens> Refresh(string refreshToken, string accessToken);
    Task RemoveUserRefreshTokens(Guid userId);
}
