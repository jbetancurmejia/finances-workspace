using Money.Application.Abstractions;
using Money.Application.Transactions;
using Money.Application.Workspaces;
using Money.Domain.Entities;

namespace Money.Application.Services;

public sealed class TransactionService(
    IWorkspaceRepository workspaces,
    ITransactionRepository transactions,
    IUnitOfWork unitOfWork)
{
    public async Task<TransactionSummary> RecordAsync(
        Guid userId,
        Guid workspaceId,
        TransactionKind kind,
        decimal amount,
        string description,
        DateOnly occurredOn,
        CancellationToken cancellationToken)
    {
        await EnsureMemberAsync(userId, workspaceId, cancellationToken);

        var transaction = new Transaction(workspaceId, userId, kind, amount, description, occurredOn);

        await transactions.AddAsync(transaction, cancellationToken);
        await unitOfWork.SaveChangesAsync(cancellationToken);

        return ToSummary(transaction);
    }

    public async Task<IReadOnlyList<TransactionSummary>> ListAsync(
        Guid userId,
        Guid workspaceId,
        CancellationToken cancellationToken)
    {
        await EnsureMemberAsync(userId, workspaceId, cancellationToken);

        var found = await transactions.ListByWorkspaceAsync(workspaceId, cancellationToken);

        return found.Select(ToSummary).ToList();
    }

    private async Task EnsureMemberAsync(Guid userId, Guid workspaceId, CancellationToken cancellationToken)
    {
        if (!await workspaces.IsMemberAsync(workspaceId, userId, cancellationToken))
        {
            throw new WorkspaceNotFoundException(workspaceId);
        }
    }

    private static TransactionSummary ToSummary(Transaction transaction) => new(
        transaction.Id,
        transaction.Kind,
        transaction.Amount,
        transaction.Description,
        transaction.OccurredOn,
        transaction.CreatedByUserId);
}
