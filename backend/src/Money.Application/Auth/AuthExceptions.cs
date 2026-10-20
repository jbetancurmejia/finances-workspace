namespace Money.Application.Auth;

public sealed class EmailAlreadyRegisteredException(string email)
    : Exception($"The email '{email}' is already registered.");

public sealed class InvalidCredentialsException() : Exception("Invalid email or password.");
