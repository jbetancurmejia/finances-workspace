using Money.Domain.Entities;

namespace Money.Application.Abstractions;

public interface IUserProfileRepository
{
    Task<UserProfile?> GetDefaultAsync(CancellationToken cancellationToken);
}
