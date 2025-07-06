using System.Reflection;
using FinancIA.Core.Application.ServiceContracts;
using FinancIA.Core.Application.Services;
using Microsoft.Extensions.DependencyInjection;

namespace FinancIA.Core.Application
{
    public static class ServiceRegistration
    {
        public static void AddApplicationLayer(this IServiceCollection services)
        {
            services.AddAutoMapper(Assembly.GetExecutingAssembly());
            services.AddTransient<IJwtService, JwtService>();
        }
    }
}
