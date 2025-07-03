using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using FinancIA.Core.Application.Contracts.Services;
using FinancIA.Core.Application.Identity;
using FinancIA.Core.Domain.Exceptions;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

namespace FinancIA.Presentation.Api.Extensions;

public static class ProgramExtensions
{
    public static void SetupCors(this IServiceCollection services)
    {
        services.AddCors(opt => opt.AddPolicy("AllowAll", builder =>
        {
            builder.AllowAnyOrigin()
                .AllowAnyHeader()
                .AllowAnyMethod();
        }));
    }

    public static IServiceCollection SetupAuthentication(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddAuthentication(opt =>
        {
            opt.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
            opt.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            opt.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
        })
        .AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, opt =>
        {
            opt.TokenValidationParameters = new TokenValidationParameters
            {
                ValidateAudience = true,
                ValidateIssuer = true,
                ValidateIssuerSigningKey = true,
                ValidateLifetime = true,
                ValidIssuer = configuration["JwtSettings:Issuer"],
                ValidAudience = configuration["JwtSettings:Audience"],
                ClockSkew = TimeSpan.Zero,
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["JwtSettings:Key"]!))
            };
            opt.Events = new JwtBearerEvents
            {
                OnTokenValidated = async context =>
                {
                    var userManager = context.HttpContext.RequestServices.GetRequiredService<UserManager<ApplicationUser>>();
                    var refreshTokenStore = context.HttpContext.RequestServices.GetRequiredService<IJwtService>();

                    Guid userId = Guid.Parse(context.Principal!.FindFirstValue(JwtRegisteredClaimNames.Sub)!);

                    if (!await refreshTokenStore.HasValidRefreshToken(userId))
                    {
                        throw new ApiException(StatusCodes.Status401Unauthorized, "El token es inválido porque no hay un refresh token activo.");
                    }
                }
            };
        });
        return services;
    }

    public static IServiceCollection SetupSwagger(this IServiceCollection services)
    {
        services.AddSwaggerGen(opt =>
        {
            opt.SwaggerDoc("v1", new OpenApiInfo
            {
                Version = "v1",
                Title = "FinancIA API",
                Description = "FinancIA API"
            });

            opt.AddSecurityDefinition(JwtBearerDefaults.AuthenticationScheme, new OpenApiSecurityScheme
            {
                Name = "Authorization",
                Type = SecuritySchemeType.ApiKey,
                Scheme = "Bearer",
                BearerFormat = "JWT",
                In = ParameterLocation.Header,
                Description = "Ingresa tu token en este formato: Bearer {tu-token-aqui}"
            });

            opt.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference
                            {
                                Type = ReferenceType.SecurityScheme,
                                Id = "Bearer"
                            }
                        },
                        Array.Empty<string>()
                    }
                });
        });
        return services;
    }
}