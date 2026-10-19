using Money.Domain.ValueObjects;

namespace Money.Domain.Entities;

public sealed class UserProfile : Entity
{
    public const decimal WorkHoursPerDay = 8m;

    private UserProfile()
    {
    }

    public UserProfile(Guid userId, decimal monthlySalary, decimal monthlyWorkHours)
    {
        if (monthlySalary <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(monthlySalary), "Monthly salary must be positive.");
        }

        if (monthlyWorkHours <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(monthlyWorkHours), "Monthly work hours must be positive.");
        }

        UserId = userId;
        MonthlySalary = monthlySalary;
        MonthlyWorkHours = monthlyWorkHours;
    }

    public Guid UserId { get; private set; }

    public decimal MonthlySalary { get; private set; }

    public decimal MonthlyWorkHours { get; private set; }

    public decimal HourlyRate => MonthlySalary / MonthlyWorkHours;

    public LifeCost CalculateLifeCost(decimal amount)
    {
        if (amount <= 0)
        {
            throw new ArgumentOutOfRangeException(nameof(amount), "Amount must be positive.");
        }

        var hours = Math.Round(amount / HourlyRate, 2, MidpointRounding.AwayFromZero);
        var days = Math.Round(hours / WorkHoursPerDay, 2, MidpointRounding.AwayFromZero);

        return new LifeCost(hours, days);
    }
}
