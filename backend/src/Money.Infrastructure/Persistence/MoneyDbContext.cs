using Microsoft.EntityFrameworkCore;
using Money.Domain.Entities;
using Money.Domain.Loans;

namespace Money.Infrastructure.Persistence;

public sealed class MoneyDbContext(DbContextOptions<MoneyDbContext> options) : DbContext(options)
{
    public DbSet<User> Users => Set<User>();

    public DbSet<UserProfile> UserProfiles => Set<UserProfile>();

    public DbSet<Workspace> Workspaces => Set<Workspace>();

    public DbSet<WorkspaceMember> WorkspaceMembers => Set<WorkspaceMember>();

    public DbSet<Transaction> Transactions => Set<Transaction>();

    public DbSet<Loan> Loans => Set<Loan>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(MoneyDbContext).Assembly);
    }
}
