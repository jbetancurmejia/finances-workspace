using Money.Domain.Entities;

namespace Money.Application.Abstractions;

public interface IUserProfileRepository
{
    Task<UserProfile?> GetByUserIdAsync(Guid userId, CancellationToken cancellationToken);

    Task AddAsync(UserProfile profile, CancellationToken cancellationToken);
}
