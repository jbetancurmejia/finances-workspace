using Money.Domain.Loans;

namespace Money.Application.Loans;

public sealed record LoanSummary(Loan Loan, IReadOnlyList<LoanInstallment> Installments);
