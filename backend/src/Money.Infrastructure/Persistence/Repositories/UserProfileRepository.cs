using Microsoft.EntityFrameworkCore;
using Money.Application.Abstractions;
using Money.Domain.Entities;

namespace Money.Infrastructure.Persistence.Repositories;

public sealed class UserProfileRepository(MoneyDbContext context) : IUserProfileRepository
{
    public Task<UserProfile?> GetByUserIdAsync(Guid userId, CancellationToken cancellationToken)
    {
        return context.UserProfiles
            .AsNoTracking()
            .FirstOrDefaultAsync(profile => profile.UserId == userId, cancellationToken);
    }

    public async Task AddAsync(UserProfile profile, CancellationToken cancellationToken)
    {
        await context.UserProfiles.AddAsync(profile, cancellationToken);
    }
}
