using Money.Application.Abstractions;
using Money.Domain.ValueObjects;

namespace Money.Application.Services;

public sealed class LifeCostService(IUserProfileRepository profiles)
{
    public async Task<LifeCost> CalculateAsync(Guid userId, decimal amount, CancellationToken cancellationToken)
    {
        var profile = await profiles.GetByUserIdAsync(userId, cancellationToken)
            ?? throw new InvalidOperationException("No user profile is configured for this user.");

        return profile.CalculateLifeCost(amount);
    }
}
