using Microsoft.EntityFrameworkCore;
using Money.Application.Abstractions;
using Money.Domain.Entities;

namespace Money.Infrastructure.Persistence.Repositories;

public sealed class UserProfileRepository(MoneyDbContext context) : IUserProfileRepository
{
    public Task<UserProfile?> GetDefaultAsync(CancellationToken cancellationToken)
    {
        return context.UserProfiles.AsNoTracking().FirstOrDefaultAsync(cancellationToken);
    }
}
