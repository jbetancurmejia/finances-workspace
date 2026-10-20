using FluentAssertions;
using Money.Domain.Loans;

namespace Money.UnitTests.Domain.Loans;

public sealed class LoanAmortizationCalculatorTests
{
    [Fact]
    public void ConvertAnnualEffectiveToMonthly_WhenRateIs20Percent_ReturnsAbout153Percent()
    {
        // Arrange & Act
        var monthlyRate = LoanAmortizationCalculator.ConvertAnnualEffectiveToMonthly(20m);

        // Assert
        monthlyRate.Should().BeApproximately(0.01530947m, 0.00000001m);
    }

    [Fact]
    public void GenerateSchedule_WhenLoanHas20PercentEa_GeneratesFrenchAmortization()
    {
        // Arrange
        var loan = new Loan(Guid.NewGuid(), 1_000_000m, 20m, 12, new DateOnly(2026, 1, 31));

        // Act
        var schedule = LoanAmortizationCalculator.GenerateSchedule(loan);

        // Assert
        schedule.Should().HaveCount(12);
        schedule.Take(11).Select(item => item.Payment).Distinct().Should().ContainSingle();
        schedule[0].Payment.Should().Be(91_856.82m);
        schedule[0].InterestPayment.Should().Be(15_309.47m);
        schedule[0].PrincipalPayment.Should().Be(76_547.35m);
        schedule[^1].RemainingBalance.Should().Be(0m);
        schedule.Sum(item => item.PrincipalPayment).Should().Be(1_000_000m);
        schedule[0].InterestPayment.Should().BeGreaterThan(schedule[^1].InterestPayment);
        schedule[0].DueDate.Should().Be(new DateOnly(2026, 2, 28));
    }

    [Fact]
    public void GenerateSchedule_WhenRateIsZero_DividesPrincipalEvenlyAndPaysFinalBalance()
    {
        // Arrange
        var loan = new Loan(Guid.NewGuid(), 1_000m, 0m, 3, new DateOnly(2026, 1, 15));

        // Act
        var schedule = LoanAmortizationCalculator.GenerateSchedule(loan);

        // Assert
        schedule.Select(item => item.Payment).Should().Equal(333.33m, 333.33m, 333.34m);
        schedule[^1].RemainingBalance.Should().Be(0m);
        schedule.Sum(item => item.InterestPayment).Should().Be(0m);
    }
}
