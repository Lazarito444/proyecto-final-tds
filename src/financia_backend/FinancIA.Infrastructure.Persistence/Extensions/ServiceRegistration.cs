using FinancIA.Core.Application.Contracts.Repositories;
using FinancIA.Core.Application.Contracts.Services;
using FinancIA.Core.Application.Identity;
using FinancIA.Infrastructure.Persistence.Repositories;
using FinancIA.Infrastructure.Persistence.Services;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace FinancIA.Infrastructure.Persistence.Extensions
{
    public static class ServiceRegistration
    {
        public static void AddPersistenceLayer(this IServiceCollection services, IConfiguration config)
        {
            services.AddScoped(typeof(IGenericRepository<>), typeof(GenericRepository<>));
            services.AddScoped<IAiService, AiService>();


            services.AddIdentity<ApplicationUser, IdentityRole<Guid>>(options =>
            {
                options.Password.RequiredLength = 6;
                options.Password.RequireNonAlphanumeric = false;
                options.Password.RequireUppercase = false;
                options.Password.RequireLowercase = true;
                options.Password.RequireDigit = true;

            })
                .AddEntityFrameworkStores<ApplicationDbContext>()
                .AddDefaultTokenProviders();

            var conn = config.GetConnectionString("DefaultConnection");
            services.AddDbContext<ApplicationDbContext>(options =>
            options.UseSqlServer(conn, m => m.MigrationsAssembly(typeof(ApplicationDbContext).Assembly.FullName)));
        }
    }
}