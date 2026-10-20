namespace Money.Domain.Loans;

public sealed class Loan
{
    private Loan()
    {
    }

    public Loan(Guid userId, decimal principal, decimal annualEffectiveRatePercent, int termMonths, DateOnly startDate)
    {
        if (principal <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(principal), "Principal must be positive.");
        }

        if (principal != decimal.Truncate(principal))
        {
            throw new ArgumentException("Principal must be whole pesos.", nameof(principal));
        }

        if (annualEffectiveRatePercent < 0 || annualEffectiveRatePercent > 1000)
        {
            throw new ArgumentOutOfRangeException(nameof(annualEffectiveRatePercent));
        }

        if (termMonths is < 1 or > 600)
        {
            throw new ArgumentOutOfRangeException(nameof(termMonths));
        }

        if (startDate == default)
        {
            throw new ArgumentOutOfRangeException(nameof(startDate));
        }

        Id = Guid.NewGuid();
        UserId = userId;
        Principal = principal;
        AnnualEffectiveRatePercent = annualEffectiveRatePercent;
        TermMonths = termMonths;
        StartDate = startDate;
    }

    public Guid Id { get; private set; }

    public Guid UserId { get; private set; }

    public decimal Principal { get; private set; }

    public decimal AnnualEffectiveRatePercent { get; private set; }

    public int TermMonths { get; private set; }

    public DateOnly StartDate { get; private set; }
}
