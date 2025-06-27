using System.Reflection;
using FinancIA.Core.Application.Contracts.Services;
using FinancIA.Core.Application.Services;
using FluentValidation;
using Microsoft.Extensions.DependencyInjection;

namespace FinancIA.Core.Application.Extensions;

public static class ApplicationExtensions
{
    public static void AddApplicationLayer(this IServiceCollection services)
    {
        services.AddValidatorsFromAssemblyContaining(typeof(ApplicationExtensions));
        services.AddAutoMapper(Assembly.GetExecutingAssembly());
        services.AddScoped<IJwtService, JwtService>();
    }
}
