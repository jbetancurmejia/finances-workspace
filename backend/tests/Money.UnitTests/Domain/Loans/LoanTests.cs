using FluentAssertions;
using Money.Domain.Loans;

namespace Money.UnitTests.Domain.Loans;

public sealed class LoanTests
{
    [Fact]
    public void Constructor_WhenPrincipalHasCentavos_ThrowsArgumentException()
    {
        // Arrange & Act
        var act = () => new Loan(Guid.NewGuid(), 100.50m, 20m, 12, new DateOnly(2026, 1, 1));

        // Assert
        act.Should().Throw<ArgumentException>().WithParameterName("principal");
    }

    [Fact]
    public void Constructor_WhenTermExceedsMaximum_ThrowsArgumentOutOfRangeException()
    {
        // Arrange & Act
        var act = () => new Loan(Guid.NewGuid(), 1000m, 20m, 601, new DateOnly(2026, 1, 1));

        // Assert
        act.Should().Throw<ArgumentOutOfRangeException>().WithParameterName("termMonths");
    }

    [Fact]
    public void Constructor_WhenStartDateIsDefault_ThrowsArgumentOutOfRangeException()
    {
        // Arrange & Act
        var act = () => new Loan(Guid.NewGuid(), 1000m, 20m, 12, default);

        // Assert
        act.Should().Throw<ArgumentOutOfRangeException>().WithParameterName("startDate");
    }
}
