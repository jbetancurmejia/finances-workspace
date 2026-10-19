namespace Money.Application.Auth;

public sealed record RegisterUserCommand(
    string Email,
    string Password,
    string DisplayName,
    decimal MonthlySalary,
    decimal MonthlyWorkHours);
