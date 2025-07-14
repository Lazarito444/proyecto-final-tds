using FinancIA.Core.Application.Identity;
using FinancIA.Core.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace FinancIA.Infrastructure.Persistence.Configurations;
public class BudgetConfiguration : IEntityTypeConfiguration<Budget>
{
    public void Configure(EntityTypeBuilder<Budget> builder)
    {
        builder.ToTable("Budgets");
        builder.HasKey(b => b.Id);

        builder.Property(b => b.UserId)
            .IsRequired();

        builder.Property(b => b.CategoryId)
            .IsRequired();

        builder.Property(b => b.StartDate)
            .IsRequired();

        builder.Property(b => b.EndDate)
            .IsRequired();

        builder.Property(b => b.IsRecurring)
            .IsRequired();

        builder.Property(b => b.MaximumAmount)
            .IsRequired()
            .HasColumnType("DECIMAL(13,4)");

        builder.HasOne(b => b.Category)
            .WithMany()
            .HasForeignKey(b => b.CategoryId)
            .OnDelete(DeleteBehavior.NoAction);

        builder.HasOne<ApplicationUser>()
            .WithMany()
            .HasForeignKey(b => b.UserId)
            .OnDelete(DeleteBehavior.NoAction);
    }
}
