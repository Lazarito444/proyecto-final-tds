
using FinancIA.Core.Application.Dtos;
using FinancIA.Core.Application.Identity;
using FinancIA.Core.Application.ServiceContracts;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace FinancIA.Core.Application.Services
{
    public class JwtService : IJwtService
    {
        private readonly IConfiguration _configuration;

        public JwtService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public AuthenticationReponse CreateJwtToken(ApplicationUser user)
        {

            // En tu JwtService.cs
            var expirationMinutes = Convert.ToDouble(_configuration["Jwt:EXPIRATION_MINUTES"] ?? "120");
            var expiration = DateTime.UtcNow.AddMinutes(expirationMinutes);

            // 2. Creación de claims
            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(JwtRegisteredClaimNames.Iat, DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString(), ClaimValueTypes.Integer64),
                new Claim(ClaimTypes.NameIdentifier, user.Email),
                new Claim(ClaimTypes.Name, user.PersonName)
            };

            // 3. Configuración de la clave de seguridad
            var securityKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(_configuration["Jwt:Key"] ?? throw new InvalidOperationException("JWT Key no configurada")));

            var signingCredentials = new SigningCredentials(
                securityKey,
                SecurityAlgorithms.HmacSha256);

            // 4. Generación del token
            var token = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"],
                audience: _configuration["Jwt:Audience"],
                claims: claims,
                expires: expiration,
                signingCredentials: signingCredentials);

            // 5. Escritura del token
            var tokenHandler = new JwtSecurityTokenHandler();
            var tokenString = tokenHandler.WriteToken(token);

            // 6. Retorno de la respuesta
            return new AuthenticationReponse
            {
                Token = tokenString,
                Email = user.Email,
                PersonName = user.PersonName,
                Expiration = expiration
            };
        }
    }
}




