using System.ComponentModel.DataAnnotations;

namespace Money.Api.Contracts;

public sealed class CreateLoanRequest
{
    [Range(1L, 999999999999L)]
    public long Principal { get; init; }

    [Range(0d, 1000d)]
    public decimal AnnualEffectiveRatePercent { get; init; }

    [Range(1, 600)]
    public int TermMonths { get; init; }

    [Required]
    public DateOnly StartDate { get; init; }
}

public sealed record LoanInstallmentResponse(
    int Number,
    DateOnly DueDate,
    decimal Payment,
    decimal PrincipalPayment,
    decimal InterestPayment,
    decimal RemainingBalance);

public sealed record LoanResponse(
    Guid Id,
    long Principal,
    decimal AnnualEffectiveRatePercent,
    decimal MonthlyRatePercent,
    int TermMonths,
    DateOnly StartDate,
    decimal FixedMonthlyPayment,
    IReadOnlyList<LoanInstallmentResponse> Installments);
