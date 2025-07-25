using FinancIA.Core.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace FinancIA.Infrastructure.Persistence.Configurations;
public class SavingTransactionConfiguration : IEntityTypeConfiguration<SavingTransaction>
{
    public void Configure(EntityTypeBuilder<SavingTransaction> builder)
    {
        builder.HasKey(st => st.Id);

        builder.Property(st => st.Amount)
            .IsRequired()
            .HasColumnType("decimal(19,4)");

        builder.Property(st => st.DateTime)
            .IsRequired();

        builder.Property(st => st.Note)
            .HasMaxLength(255);

        builder.HasOne(st => st.Saving)
            .WithMany(s => s.Transactions)
            .HasForeignKey(st => st.SavingId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
