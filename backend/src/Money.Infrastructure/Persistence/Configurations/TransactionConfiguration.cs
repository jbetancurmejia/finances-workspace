using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Money.Domain.Entities;

namespace Money.Infrastructure.Persistence.Configurations;

public sealed class TransactionConfiguration : IEntityTypeConfiguration<Transaction>
{
    public void Configure(EntityTypeBuilder<Transaction> builder)
    {
        builder.ToTable("Transactions");
        builder.HasKey(transaction => transaction.Id);
        builder.Property(transaction => transaction.Amount).HasPrecision(18, 2);
        builder.Property(transaction => transaction.Description).HasMaxLength(120).IsRequired();
        builder.Property(transaction => transaction.Kind).HasConversion<string>().HasMaxLength(16);
        builder.HasIndex(transaction => new { transaction.WorkspaceId, transaction.OccurredOn });
    }
}
