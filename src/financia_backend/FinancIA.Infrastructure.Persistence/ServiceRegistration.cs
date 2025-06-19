using FinancIA.Infrastructure.Persistence.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace FinancIA.Infrastructure.Persistence
{
    public static class ServiceRegistration
    {
        public static void AddPersistenceInfrastructure(this IServiceCollection services, IConfiguration config)
        {
            services.AddIdentity<ApplicationUser, IdentityRole<int>>()
                .AddEntityFrameworkStores<ApplicationContext>()
                .AddDefaultTokenProviders();

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