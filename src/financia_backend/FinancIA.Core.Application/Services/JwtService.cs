using FinancIA.Core.Application.Dtos;
using FinancIA.Core.Application.Identity;
using FinancIA.Core.Application.ServiceContracts;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace FinancIA.Core.Application.Services
{
    public class JwtService : IJwtService
    {
        private readonly IConfiguration _configuration;

        public JwtService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public AuthenticationReponse CreateJwtToke(ApplicationUser user)
        {
          DateTime expiraton =  DateTime.UtcNow.AddMinutes(Convert.ToDouble(_configuration["Jwt:EXPIRATION_MINUTES"]));

            Claim[] claims = new Claim[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
                 new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()), //Jwt Unique Id
                   new Claim(JwtRegisteredClaimNames.Iat,DateTime.UtcNow.ToString()),
                   new Claim(ClaimTypes.NameIdentifier, user.Email),
                   new Claim(ClaimTypes.Name, user.PersonName)
            };


            SymmetricSecurityKey securityKey = new SymmetricSecurityKey(
               Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));

            SigningCredentials signingCredentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            JwtSecurityToken tokenGenerator = new JwtSecurityToken(
                _configuration["Jwt:Issuer"],
                _configuration["Jwt:Audience"],
                claims,
                expires: expiraton,
               signingCredentials: signingCredentials);


          JwtSecurityTokenHandler tokenHandler = new JwtSecurityTokenHandler();

           string token = tokenHandler.WriteToken(tokenGenerator);

            return new AuthenticationReponse() { Token = token, Email = user.Email, PersonName = user.PersonName, Expiration = expiraton };
        }
    }
}
