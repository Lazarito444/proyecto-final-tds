using FinancIA.Core.Application.Identity;
using FinancIA.Core.Domain.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace FinancIA.Infrastructure.Persistence.Configurations;
public class ApplicationUserConfiguration : IEntityTypeConfiguration<ApplicationUser>
{
    public void Configure(EntityTypeBuilder<ApplicationUser> builder)
    {
        builder.Property(u => u.Email).IsRequired();

        builder.Property(u => u.FullName).IsRequired()
            .HasColumnType("VARCHAR(150)");

        builder.Property(u => u.DateOfBirth)
            .IsRequired(false)
            .HasColumnType("DATE");

        builder.Property(u => u.Gender)
            .HasDefaultValue(Gender.Unspecified);

        builder.Property(u => u.ImagePath)
            .IsRequired(false)
            .HasColumnType("VARCHAR(200)");
    }
}
