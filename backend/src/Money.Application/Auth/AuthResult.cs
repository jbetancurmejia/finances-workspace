namespace Money.Application.Auth;

public sealed record AuthResult(string Token, Guid UserId, string DisplayName);
