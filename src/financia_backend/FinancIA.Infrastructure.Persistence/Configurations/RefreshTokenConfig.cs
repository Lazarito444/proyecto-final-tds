using FinancIA.Core.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace FinancIA.Infrastructure.Persistence.Configurations
{
    public class RefreshTokenConfig : IEntityTypeConfiguration<RefreshToken>
    {
        public void Configure(EntityTypeBuilder<RefreshToken> builder)
        {
            builder.ToTable("RefreshTokens");

            builder.Property(t => t.UserId)
                .IsRequired();

            builder.Property(t => t.Token)
                .IsRequired()
                .HasColumnType("VARCHAR(100)");

            builder.Property(t => t.Created)
                .IsRequired()
                .HasColumnType("DATETIME");

            builder.Property(t => t.Expires)
                .IsRequired()
                .HasColumnType("DATETIME");

            builder.Property(t => t.Revoked)
                .HasColumnType("DATETIME");
        }
    }
}
