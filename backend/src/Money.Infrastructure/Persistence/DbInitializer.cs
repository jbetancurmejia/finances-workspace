using Microsoft.Extensions.DependencyInjection;

namespace Money.Infrastructure.Persistence;

public static class DbInitializer
{
    public static void Initialize(IServiceProvider services)
    {
        using var scope = services.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<MoneyDbContext>();
        context.Database.EnsureCreated();
    }
}
