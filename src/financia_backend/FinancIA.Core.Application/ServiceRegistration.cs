using System.Reflection;
using Microsoft.Extensions.DependencyInjection;

namespace FinancIA.Core.Application
{
    public static class ServiceRegistration
    {
        public static void AddApplicationLayer(this IServiceCollection services)
        {
            services.AddAutoMapper(Assembly.GetExecutingAssembly());
        }
    }
}
