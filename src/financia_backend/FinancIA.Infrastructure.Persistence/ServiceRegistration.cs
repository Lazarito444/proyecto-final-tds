using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FinancIA.Infrastructure.Persistence
{
    public static class ServiceRegistration
    {
        public static void AddPersistenceInfrastructure(this IServiceCollection services, IConfiguration config)
        {
            if (config.GetValue<bool>("UseInMemoryDatabase"))
            {
                services.AddDbContext<ApplicationContext>(options => options.UseInMemoryDatabase("applicationDB"));

            }
            else
            {
                var conn = config.GetConnectionString("DefaultConnection");
                services.AddDbContext<ApplicationContext>(options =>
                options.UseSqlServer(conn, m => m.MigrationsAssembly(typeof(ApplicationContext).Assembly.FullName)));

            }

        }
    }
}