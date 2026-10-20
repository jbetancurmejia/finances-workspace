namespace Money.Domain.Entities;

public enum TransactionKind
{
    Expense,
    Income
}

public sealed class Transaction : Entity
{
    private Transaction()
    {
    }

    public Transaction(
        Guid workspaceId,
        Guid createdByUserId,
        TransactionKind kind,
        decimal amount,
        string description,
        DateOnly occurredOn)
    {
        if (amount <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(amount), "Amount must be positive.");
        }

        if (amount != decimal.Truncate(amount))
        {
            throw new ArgumentException("Amount must be whole pesos.", nameof(amount));
        }

        ArgumentException.ThrowIfNullOrWhiteSpace(description);

        WorkspaceId = workspaceId;
        CreatedByUserId = createdByUserId;
        Kind = kind;
        Amount = amount;
        Description = description.Trim();
        OccurredOn = occurredOn;
    }

    public Guid WorkspaceId { get; private set; }

    public Guid CreatedByUserId { get; private set; }

    public TransactionKind Kind { get; private set; }

    public decimal Amount { get; private set; }

    public string Description { get; private set; } = string.Empty;

    public DateOnly OccurredOn { get; private set; }
}
