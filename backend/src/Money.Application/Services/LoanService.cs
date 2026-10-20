using Money.Application.Abstractions;
using Money.Application.Loans;
using Money.Domain.Loans;

namespace Money.Application.Services;

public sealed class LoanService(ILoanRepository loans, IUnitOfWork unitOfWork)
{
    public async Task<LoanSummary> CreateAsync(
        Guid userId,
        decimal principal,
        decimal annualEffectiveRatePercent,
        int termMonths,
        DateOnly startDate,
        CancellationToken cancellationToken)
    {
        var loan = new Loan(userId, principal, annualEffectiveRatePercent, termMonths, startDate);
        await loans.AddAsync(loan, cancellationToken);
        await unitOfWork.SaveChangesAsync(cancellationToken);

        return new LoanSummary(loan, LoanAmortizationCalculator.GenerateSchedule(loan));
    }

    public async Task<IReadOnlyList<LoanSummary>> ListForUserAsync(Guid userId, CancellationToken cancellationToken)
    {
        var found = await loans.ListForUserAsync(userId, cancellationToken);

        return found
            .Select(loan => new LoanSummary(loan, LoanAmortizationCalculator.GenerateSchedule(loan)))
            .ToList();
    }
}
