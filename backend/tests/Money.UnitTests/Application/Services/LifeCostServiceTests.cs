using FluentAssertions;
using Money.Application.Abstractions;
using Money.Application.Services;
using Money.Domain.Entities;

namespace Money.UnitTests.Application.Services;

public sealed class LifeCostServiceTests
{
    private sealed class FakeUserProfileRepository(UserProfile? profile) : IUserProfileRepository
    {
        public Task<UserProfile?> GetDefaultAsync(CancellationToken cancellationToken)
        {
            return Task.FromResult(profile);
        }
    }

    [Fact]
    public async Task CalculateAsync_WhenProfileExists_ReturnsLifeCostFromProfile()
    {
        // Arrange
        var profile = new UserProfile(monthlySalary: 2_000_000m, monthlyWorkHours: 160m);
        var service = new LifeCostService(new FakeUserProfileRepository(profile));

        // Act
        var lifeCost = await service.CalculateAsync(300_000m, CancellationToken.None);

        // Assert
        lifeCost.Hours.Should().Be(24m);
        lifeCost.Days.Should().Be(3m);
    }

    [Fact]
    public async Task CalculateAsync_WhenNoProfileExists_ThrowsInvalidOperationException()
    {
        // Arrange
        var service = new LifeCostService(new FakeUserProfileRepository(null));

        // Act
        var act = () => service.CalculateAsync(300_000m, CancellationToken.None);

        // Assert
        await act.Should().ThrowAsync<InvalidOperationException>();
    }
}
