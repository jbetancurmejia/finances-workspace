using Microsoft.EntityFrameworkCore;
using Money.Application.Abstractions;
using Money.Domain.Entities;

namespace Money.Infrastructure.Persistence.Repositories;

public sealed class WorkspaceRepository(MoneyDbContext context) : IWorkspaceRepository
{
    public async Task AddAsync(Workspace workspace, CancellationToken cancellationToken)
    {
        await context.Workspaces.AddAsync(workspace, cancellationToken);
    }

    public async Task AddMemberAsync(WorkspaceMember member, CancellationToken cancellationToken)
    {
        await context.WorkspaceMembers.AddAsync(member, cancellationToken);
    }

    public Task<Workspace?> GetByIdAsync(Guid workspaceId, CancellationToken cancellationToken)
    {
        return context.Workspaces
            .AsNoTracking()
            .FirstOrDefaultAsync(workspace => workspace.Id == workspaceId, cancellationToken);
    }

    public Task<bool> IsMemberAsync(Guid workspaceId, Guid userId, CancellationToken cancellationToken)
    {
        return context.WorkspaceMembers.AnyAsync(
            member => member.WorkspaceId == workspaceId && member.UserId == userId,
            cancellationToken);
    }

    public async Task<List<Workspace>> ListForUserAsync(Guid userId, CancellationToken cancellationToken)
    {
        return await context.WorkspaceMembers
            .AsNoTracking()
            .Where(member => member.UserId == userId)
            .Join(
                context.Workspaces.AsNoTracking(),
                member => member.WorkspaceId,
                workspace => workspace.Id,
                (_, workspace) => workspace)
            .OrderBy(workspace => workspace.Name)
            .ToListAsync(cancellationToken);
    }
}
