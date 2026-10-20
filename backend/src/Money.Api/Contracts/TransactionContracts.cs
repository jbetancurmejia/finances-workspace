using System.ComponentModel.DataAnnotations;
using Money.Domain.Entities;

namespace Money.Api.Contracts;

public sealed class RecordTransactionRequest
{
    [Required]
    public TransactionKind Kind { get; init; }

    [Range(1d, 999999999999d)]
    public long Amount { get; init; }

    [Required, StringLength(120, MinimumLength = 1)]
    public string Description { get; init; } = string.Empty;

    [Required]
    public DateOnly OccurredOn { get; init; }
}

public sealed record TransactionResponse(
    Guid Id,
    string Kind,
    long Amount,
    string Description,
    DateOnly OccurredOn,
    Guid CreatedByUserId);
