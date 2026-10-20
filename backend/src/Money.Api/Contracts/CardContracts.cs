namespace Money.Api.Contracts;

public sealed record CardResponse(Guid Id, string Name, bool IsOwner, long Balance, string Status);
