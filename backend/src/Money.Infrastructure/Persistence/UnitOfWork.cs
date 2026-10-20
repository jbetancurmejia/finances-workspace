using Money.Application.Abstractions;

namespace Money.Infrastructure.Persistence;

public sealed class UnitOfWork(MoneyDbContext context) : IUnitOfWork
{
    public Task SaveChangesAsync(CancellationToken cancellationToken)
    {
        return context.SaveChangesAsync(cancellationToken);
    }
}
