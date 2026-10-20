using FluentAssertions;
using Money.Domain.Rules;

namespace Money.UnitTests.Domain.Rules;

public sealed class CardStatusRuleTests
{
    [Fact]
    public void Evaluate_WhenNoMovements_ReturnsRed()
    {
        // Arrange & Act
        var status = CardStatusRule.Evaluate(0m, 0m);

        // Assert
        status.Should().Be(CardStatus.Red);
    }

    [Fact]
    public void Evaluate_WhenExpenseEqualsIncome_ReturnsRed()
    {
        // Arrange & Act
        var status = CardStatusRule.Evaluate(1_000_000m, 1_000_000m);

        // Assert
        status.Should().Be(CardStatus.Red);
    }

    [Fact]
    public void Evaluate_WhenExpenseExceedsIncome_ReturnsRed()
    {
        // Arrange & Act
        var status = CardStatusRule.Evaluate(500_000m, 600_000m);

        // Assert
        status.Should().Be(CardStatus.Red);
    }

    [Fact]
    public void Evaluate_WhenBalanceIsBelowTwentyPercentOfIncome_ReturnsYellow()
    {
        // Arrange & Act
        var status = CardStatusRule.Evaluate(1_000_000m, 900_000m);

        // Assert
        status.Should().Be(CardStatus.Yellow);
    }

    [Fact]
    public void Evaluate_WhenBalanceIsExactlyTwentyPercentOfIncome_ReturnsGreen()
    {
        // Arrange & Act
        var status = CardStatusRule.Evaluate(1_000_000m, 800_000m);

        // Assert
        status.Should().Be(CardStatus.Green);
    }

    [Fact]
    public void Evaluate_WhenBalanceIsHealthy_ReturnsGreen()
    {
        // Arrange & Act
        var status = CardStatusRule.Evaluate(2_000_000m, 300_000m);

        // Assert
        status.Should().Be(CardStatus.Green);
    }
}
