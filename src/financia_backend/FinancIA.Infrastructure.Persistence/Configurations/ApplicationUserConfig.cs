using FinancIA.Infrastructure.Persistence.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace FinancIA.Infrastructure.Persistence.Configurations
{
    public class ApplicationUserConfig : IEntityTypeConfiguration<ApplicationUser>
    {
        public void Configure(EntityTypeBuilder<ApplicationUser> builder)
        {
            builder.ToTable("Users");

            builder.Property(u => u.FirstName)
                .IsRequired()
                .HasColumnType("VARCHAR(120)");

            builder.Property(u => u.LastName)
                .IsRequired()
                .HasColumnType("VARCHAR(120)");

            builder.Property(u => u.DateOfBirth)
                .IsRequired()
                .HasColumnType("DATE");

            builder.Property(u => u.SignUpDate)
                .IsRequired()
                .HasColumnType("DATETIME");
        }
    }
}
