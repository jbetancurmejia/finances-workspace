using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Money.Domain.Loans;

namespace Money.Infrastructure.Persistence.Configurations;

public sealed class LoanConfiguration : IEntityTypeConfiguration<Loan>
{
    public void Configure(EntityTypeBuilder<Loan> builder)
    {
        builder.ToTable("Loans");
        builder.HasKey(loan => loan.Id);
        builder.Property(loan => loan.Principal).HasPrecision(18, 2);
        builder.Property(loan => loan.AnnualEffectiveRatePercent).HasPrecision(8, 4);
        builder.HasIndex(loan => new { loan.UserId, loan.StartDate });
    }
}
