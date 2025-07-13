using FinancIA.Core.Application.Identity;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace FinancIA.Infrastructure.Persistence
{
    public static class ServiceRegistration
    {
        public static void AddPersistenceInfrastructure(this IServiceCollection services, IConfiguration config)
        {

            //Identity
            services.AddIdentity<ApplicationUser, ApplicationRole>(options => {
                options.Password.RequiredLength = 5;
                options.Password.RequireNonAlphanumeric = false;
                options.Password.RequireUppercase = false;
                options.Password.RequireLowercase = true;
                options.Password.RequireDigit = true;

            }).AddEntityFrameworkStores<ApplicationContext>().AddDefaultTokenProviders().
            AddUserStore<UserStore<ApplicationUser, ApplicationRole, ApplicationContext, Guid>>().AddRoleStore<RoleStore<ApplicationRole, ApplicationContext, Guid>>();



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