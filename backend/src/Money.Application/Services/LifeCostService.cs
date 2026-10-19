using Money.Application.Abstractions;
using Money.Domain.ValueObjects;

namespace Money.Application.Services;

public sealed class LifeCostService(IUserProfileRepository profiles)
{
    public async Task<LifeCost> CalculateAsync(decimal amount, CancellationToken cancellationToken)
    {
        var profile = await profiles.GetDefaultAsync(cancellationToken)
            ?? throw new InvalidOperationException("No user profile is configured.");

        return profile.CalculateLifeCost(amount);
    }
}
