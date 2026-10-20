using FluentAssertions;
using Money.Domain.Entities;

namespace Money.UnitTests.Domain.Entities;

public sealed class TransactionTests
{
    private static readonly DateOnly Today = DateOnly.FromDateTime(DateTime.Today);

    [Fact]
    public void Constructor_WhenAmountIsWholePesos_KeepsAmount()
    {
        // Arrange & Act
        var transaction = new Transaction(Guid.NewGuid(), Guid.NewGuid(), TransactionKind.Expense, 300_000m, "Mercado", Today);

        // Assert
        transaction.Amount.Should().Be(300_000m);
    }

    [Fact]
    public void Constructor_WhenAmountHasDecimals_ThrowsArgumentException()
    {
        // Arrange & Act
        var act = () => new Transaction(Guid.NewGuid(), Guid.NewGuid(), TransactionKind.Expense, 10.5m, "Mercado", Today);

        // Assert
        act.Should().Throw<ArgumentException>().WithParameterName("amount");
    }

    [Fact]
    public void Constructor_WhenAmountIsNotPositive_ThrowsArgumentOutOfRangeException()
    {
        // Arrange & Act
        var act = () => new Transaction(Guid.NewGuid(), Guid.NewGuid(), TransactionKind.Expense, 0m, "Mercado", Today);

        // Assert
        act.Should().Throw<ArgumentOutOfRangeException>().WithParameterName("amount");
    }

    [Fact]
    public void Constructor_WhenDescriptionIsBlank_ThrowsArgumentException()
    {
        // Arrange & Act
        var act = () => new Transaction(Guid.NewGuid(), Guid.NewGuid(), TransactionKind.Income, 100m, " ", Today);

        // Assert
        act.Should().Throw<ArgumentException>();
    }
}
