using FluentAssertions;
using Money.Domain.Entities;

namespace Money.UnitTests.Domain.Entities;

public sealed class UserProfileTests
{
    [Fact]
    public void CalculateLifeCost_WhenAmountIs300000_ReturnsTwentyFourHoursAndThreeDays()
    {
        // Arrange
        var profile = new UserProfile(Guid.NewGuid(), monthlySalary: 2_000_000m, monthlyWorkHours: 160m);

        // Act
        var lifeCost = profile.CalculateLifeCost(300_000m);

        // Assert
        lifeCost.Hours.Should().Be(24m);
        lifeCost.Days.Should().Be(3m);
    }

    [Fact]
    public void HourlyRate_WhenSalaryAndHoursAreSet_ReturnsSalaryDividedByHours()
    {
        // Arrange
        var profile = new UserProfile(Guid.NewGuid(), monthlySalary: 2_000_000m, monthlyWorkHours: 160m);

        // Act
        var rate = profile.HourlyRate;

        // Assert
        rate.Should().Be(12_500m);
    }

    [Fact]
    public void CalculateLifeCost_WhenAmountIsNotPositive_ThrowsArgumentOutOfRangeException()
    {
        // Arrange
        var profile = new UserProfile(Guid.NewGuid(), monthlySalary: 2_000_000m, monthlyWorkHours: 160m);

        // Act
        var act = () => profile.CalculateLifeCost(0m);

        // Assert
        act.Should().Throw<ArgumentOutOfRangeException>().WithParameterName("amount");
    }

    [Fact]
    public void Constructor_WhenWorkHoursAreZero_ThrowsArgumentOutOfRangeException()
    {
        // Arrange & Act
        var act = () => new UserProfile(Guid.NewGuid(), monthlySalary: 2_000_000m, monthlyWorkHours: 0m);

        // Assert
        act.Should().Throw<ArgumentOutOfRangeException>().WithParameterName("monthlyWorkHours");
    }

    [Fact]
    public void Constructor_WhenSalaryIsNotPositive_ThrowsArgumentOutOfRangeException()
    {
        // Arrange & Act
        var act = () => new UserProfile(Guid.NewGuid(), monthlySalary: -1m, monthlyWorkHours: 160m);

        // Assert
        act.Should().Throw<ArgumentOutOfRangeException>().WithParameterName("monthlySalary");
    }
}
