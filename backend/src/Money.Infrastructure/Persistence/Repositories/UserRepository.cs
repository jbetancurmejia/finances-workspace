using Microsoft.EntityFrameworkCore;
using Money.Application.Abstractions;
using Money.Domain.Entities;

namespace Money.Infrastructure.Persistence.Repositories;

public sealed class UserRepository(MoneyDbContext context) : IUserRepository
{
    public Task<User?> GetByEmailAsync(string email, CancellationToken cancellationToken)
    {
        return context.Users.FirstOrDefaultAsync(user => user.Email == email, cancellationToken);
    }

    public async Task AddAsync(User user, CancellationToken cancellationToken)
    {
        await context.Users.AddAsync(user, cancellationToken);
    }
}
