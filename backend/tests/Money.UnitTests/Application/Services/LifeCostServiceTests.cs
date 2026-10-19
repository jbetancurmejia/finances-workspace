using FluentAssertions;
using Money.Application.Abstractions;
using Money.Application.Services;
using Money.Domain.Entities;

namespace Money.UnitTests.Application.Services;

public sealed class LifeCostServiceTests
{
    private sealed class FakeUserProfileRepository(params UserProfile[] profiles) : IUserProfileRepository
    {
        public Task<UserProfile?> GetByUserIdAsync(Guid userId, CancellationToken cancellationToken)
        {
            return Task.FromResult(profiles.FirstOrDefault(profile => profile.UserId == userId));
        }

        public Task AddAsync(UserProfile profile, CancellationToken cancellationToken)
        {
            return Task.CompletedTask;
        }
    }

    [Fact]
    public async Task CalculateAsync_WhenProfileExistsForUser_ReturnsLifeCostFromProfile()
    {
        // Arrange
        var userId = Guid.NewGuid();
        var profile = new UserProfile(userId, monthlySalary: 2_000_000m, monthlyWorkHours: 160m);
        var service = new LifeCostService(new FakeUserProfileRepository(profile));

        // Act
        var lifeCost = await service.CalculateAsync(userId, 300_000m, CancellationToken.None);

        // Assert
        lifeCost.Hours.Should().Be(24m);
        lifeCost.Days.Should().Be(3m);
    }

    [Fact]
    public async Task CalculateAsync_WhenProfileBelongsToAnotherUser_ThrowsInvalidOperationException()
    {
        // Arrange
        var profile = new UserProfile(Guid.NewGuid(), monthlySalary: 2_000_000m, monthlyWorkHours: 160m);
        var service = new LifeCostService(new FakeUserProfileRepository(profile));

        // Act
        var act = () => service.CalculateAsync(Guid.NewGuid(), 300_000m, CancellationToken.None);

        // Assert
        await act.Should().ThrowAsync<InvalidOperationException>();
    }
}
