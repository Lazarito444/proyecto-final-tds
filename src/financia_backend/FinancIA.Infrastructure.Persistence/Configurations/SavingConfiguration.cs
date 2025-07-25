using FinancIA.Core.Application.Identity;
using FinancIA.Core.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace FinancIA.Infrastructure.Persistence.Configurations;
public class SavingConfiguration : IEntityTypeConfiguration<Saving>
{
    public void Configure(EntityTypeBuilder<Saving> builder)
    {
        builder.ToTable("Savings");
        builder.HasKey(s => s.Id);

        builder.Property(s => s.UserId)
            .IsRequired();

        builder.Property(s => s.Name)
            .IsRequired()
            .HasColumnType("VARCHAR(120)");

        builder.Property(s => s.TargetAmount)
            .IsRequired()
            .HasColumnType("DECIMAL(13,4)");

        builder.Property(s => s.CurrentAmount)
            .IsRequired()
            .HasColumnType("DECIMAL(13,4)");

        builder.Property(s => s.TargetDate)
            .IsRequired(false);

        builder.HasOne<ApplicationUser>()
            .WithMany()
            .HasForeignKey(s => s.UserId)
            .OnDelete(DeleteBehavior.NoAction);
    }
}
