using Microsoft.EntityFrameworkCore;
using Money.Application.Abstractions;
using Money.Domain.Entities;

namespace Money.Infrastructure.Persistence.Repositories;

public sealed class TransactionRepository(MoneyDbContext context) : ITransactionRepository
{
    public async Task AddAsync(Transaction transaction, CancellationToken cancellationToken)
    {
        await context.Transactions.AddAsync(transaction, cancellationToken);
    }

    public async Task<List<Transaction>> ListByWorkspaceAsync(Guid workspaceId, CancellationToken cancellationToken)
    {
        return await context.Transactions
            .AsNoTracking()
            .Where(transaction => transaction.WorkspaceId == workspaceId)
            .OrderByDescending(transaction => transaction.OccurredOn)
            .ThenByDescending(transaction => transaction.Id)
            .ToListAsync(cancellationToken);
    }

    public async Task<(decimal Income, decimal Expense)> GetTotalsAsync(Guid workspaceId, CancellationToken cancellationToken)
    {
        var amounts = await context.Transactions
            .AsNoTracking()
            .Where(transaction => transaction.WorkspaceId == workspaceId)
            .Select(transaction => new { transaction.Kind, transaction.Amount })
            .ToListAsync(cancellationToken);

        var income = amounts.Where(item => item.Kind == TransactionKind.Income).Sum(item => item.Amount);
        var expense = amounts.Where(item => item.Kind == TransactionKind.Expense).Sum(item => item.Amount);

        return (income, expense);
    }
}
