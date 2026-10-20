namespace Money.Domain.Loans;

public sealed record LoanInstallment(
    int Number,
    DateOnly DueDate,
    decimal Payment,
    decimal PrincipalPayment,
    decimal InterestPayment,
    decimal RemainingBalance);
