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

        ArgumentException.ThrowIfNullOrWhiteSpace(description);

        WorkspaceId = workspaceId;
        CreatedByUserId = createdByUserId;
        Kind = kind;
        Amount = decimal.Round(amount, 2, MidpointRounding.AwayFromZero);
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
