using Microsoft.Extensions.DependencyInjection;
using Money.Application.Services;

namespace Money.Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddScoped<LifeCostService>();
        services.AddScoped<AuthService>();
        services.AddScoped<WorkspaceService>();

        return services;
    }
}
