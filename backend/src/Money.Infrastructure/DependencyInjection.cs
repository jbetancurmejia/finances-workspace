using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Money.Infrastructure.Persistence;

namespace Money.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetConnectionString("Money")
            ?? throw new InvalidOperationException("ConnectionStrings:Money is not configured.");

        services.AddDbContext<MoneyDbContext>(options => options.UseSqlite(connectionString));

        return services;
    }
}
