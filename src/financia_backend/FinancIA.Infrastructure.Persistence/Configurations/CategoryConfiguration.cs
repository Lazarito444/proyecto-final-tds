using FinancIA.Core.Application.Identity;
using FinancIA.Core.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace FinancIA.Infrastructure.Persistence.Configurations;

public class CategoryConfiguration : IEntityTypeConfiguration<Category>
{
    public void Configure(EntityTypeBuilder<Category> builder)
    {
        builder.ToTable("Category");
        builder.HasKey(c => c.Id);

        builder.Property(c => c.Id)
            .IsRequired()
            .HasColumnName("CategoryId");

        builder.Property(c => c.Name)
            .IsRequired()
            .HasColumnType("VARCHAR(200)");

        builder.Property(c => c.IsEarningCategory)
            .IsRequired()
            .HasDefaultValue(false);

        builder.Property(c => c.ColorHex)
            .IsRequired()
            .HasMaxLength(12);

        builder.Property(c => c.IconName)
            .IsRequired()
            .HasMaxLength(80);

        builder.HasOne<ApplicationUser>()
            .WithMany()
            .HasForeignKey(c => c.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(c => c.Transactions)
            .WithOne(t => t.Category)
            .HasForeignKey(t => t.CategoryId)
            .OnDelete(DeleteBehavior.Cascade);

    }
}
