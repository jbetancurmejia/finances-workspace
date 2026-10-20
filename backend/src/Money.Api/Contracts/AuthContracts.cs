using System.ComponentModel.DataAnnotations;

namespace Money.Api.Contracts;

public sealed class RegisterRequest
{
    [Required, EmailAddress, StringLength(256)]
    public string Email { get; init; } = string.Empty;

    [Required, StringLength(128, MinimumLength = 8)]
    public string Password { get; init; } = string.Empty;

    [Required, StringLength(120, MinimumLength = 1)]
    public string DisplayName { get; init; } = string.Empty;

    [Range(0.01d, 999999999999d)]
    public decimal MonthlySalary { get; init; }

    [Range(0.01d, 744d)]
    public decimal MonthlyWorkHours { get; init; }
}

public sealed class LoginRequest
{
    [Required, EmailAddress]
    public string Email { get; init; } = string.Empty;

    [Required]
    public string Password { get; init; } = string.Empty;
}

public sealed record AuthResponse(string Token, Guid UserId, string DisplayName);
