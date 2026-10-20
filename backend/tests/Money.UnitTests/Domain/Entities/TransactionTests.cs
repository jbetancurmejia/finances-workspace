using FluentAssertions;
using Money.Domain.Entities;

namespace Money.UnitTests.Domain.Entities;

public sealed class TransactionTests
{
    [Fact]
    public void Constructor_WhenAmountHasMoreThanTwoDecimals_RoundsToTwoDecimals()
    {
        // Arrange & Act
        var transaction = new Transaction(Guid.NewGuid(), Guid.NewGuid(), TransactionKind.Expense, 10.555m, "Mercado", DateOnly.FromDateTime(DateTime.Today));

        // Assert
        transaction.Amount.Should().Be(10.56m);
    }

    [Fact]
    public void Constructor_WhenAmountIsNotPositive_ThrowsArgumentOutOfRangeException()
    {
        // Arrange & Act
        var act = () => new Transaction(Guid.NewGuid(), Guid.NewGuid(), TransactionKind.Expense, 0m, "Mercado", DateOnly.FromDateTime(DateTime.Today));

        // Assert
        act.Should().Throw<ArgumentOutOfRangeException>().WithParameterName("amount");
    }

    [Fact]
    public void Constructor_WhenDescriptionIsBlank_ThrowsArgumentException()
    {
        // Arrange & Act
        var act = () => new Transaction(Guid.NewGuid(), Guid.NewGuid(), TransactionKind.Income, 100m, " ", DateOnly.FromDateTime(DateTime.Today));

        // Assert
        act.Should().Throw<ArgumentException>();
    }
}
