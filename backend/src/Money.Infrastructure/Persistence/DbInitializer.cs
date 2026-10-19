using Microsoft.Extensions.DependencyInjection;
using Money.Domain.Entities;

namespace Money.Infrastructure.Persistence;

public static class DbInitializer
{
    public static void Initialize(IServiceProvider services)
    {
        using var scope = services.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<MoneyDbContext>();
        context.Database.EnsureCreated();

        if (!context.UserProfiles.Any())
        {
            context.UserProfiles.Add(new UserProfile(monthlySalary: 2_000_000m, monthlyWorkHours: 160m));
            context.SaveChanges();
        }
    }
}
