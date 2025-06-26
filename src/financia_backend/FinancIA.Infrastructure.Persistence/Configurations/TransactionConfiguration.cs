using FinancIA.Core.Application.Identity;
using FinancIA.Core.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace FinancIA.Infrastructure.Persistence.Configurations;
public class TransactionConfiguration : IEntityTypeConfiguration<Transaction>
{
    public void Configure(EntityTypeBuilder<Transaction> builder)
    {
        builder.ToTable("Transactions");
        builder.HasKey(t => t.Id);

        builder.Property(t => t.Id)
            .IsRequired()
            .HasColumnName("TransactionId");

        builder.Property(t => t.IsEarning)
            .IsRequired()
            .HasDefaultValue(false);

        builder.Property(t => t.Amount)
            .IsRequired()
            .HasColumnType("DECIMAL(19, 4)");

        builder.Property(t => t.DateTime)
            .IsRequired();

        builder.Property(t => t.Description)
            .IsRequired()
            .HasColumnType("VARCHAR(500)");

        builder.HasOne<ApplicationUser>()
            .WithMany()
            .HasForeignKey(t => t.UserId)
            .OnDelete(DeleteBehavior.NoAction);
    }
}
