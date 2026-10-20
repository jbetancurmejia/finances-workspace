using Money.Domain.Entities;

namespace Money.Application.Abstractions;

public interface ITransactionRepository
{
    Task AddAsync(Transaction transaction, CancellationToken cancellationToken);

    Task<List<Transaction>> ListByWorkspaceAsync(Guid workspaceId, CancellationToken cancellationToken);

    Task<(decimal Income, decimal Expense)> GetTotalsAsync(Guid workspaceId, CancellationToken cancellationToken);
}
