using Microsoft.EntityFrameworkCore;

namespace Money.Infrastructure.Persistence;

public sealed class MoneyDbContext(DbContextOptions<MoneyDbContext> options) : DbContext(options)
{
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(MoneyDbContext).Assembly);
    }
}
