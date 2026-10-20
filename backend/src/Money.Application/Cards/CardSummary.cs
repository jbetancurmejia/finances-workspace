using Money.Domain.Rules;

namespace Money.Application.Cards;

public sealed record CardSummary(Guid Id, string Name, bool IsOwner, decimal Balance, CardStatus Status);
