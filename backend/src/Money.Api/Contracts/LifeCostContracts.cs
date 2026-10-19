using System.ComponentModel.DataAnnotations;

namespace Money.Api.Contracts;

public sealed class CalculateLifeCostRequest
{
    [Range(0.01d, 999999999999d)]
    public decimal Amount { get; init; }
}

public sealed record LifeCostResponse(decimal Hours, decimal Days);
