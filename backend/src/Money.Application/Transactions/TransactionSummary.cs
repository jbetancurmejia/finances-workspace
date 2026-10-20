using Money.Domain.Entities;

namespace Money.Application.Transactions;

public sealed record TransactionSummary(
    Guid Id,
    TransactionKind Kind,
    decimal Amount,
    string Description,
    DateOnly OccurredOn,
    Guid CreatedByUserId);
