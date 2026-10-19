using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Money.Application.Abstractions;
using Money.Infrastructure.Persistence;
using Money.Infrastructure.Persistence.Repositories;

namespace Money.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetConnectionString("Money")
            ?? throw new InvalidOperationException("ConnectionStrings:Money is not configured.");

        services.AddDbContext<MoneyDbContext>(options => options.UseSqlite(connectionString));
        services.AddScoped<IUserProfileRepository, UserProfileRepository>();

        return services;
    }
}
