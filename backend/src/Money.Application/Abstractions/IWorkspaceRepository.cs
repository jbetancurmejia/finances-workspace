using Money.Domain.Entities;

namespace Money.Application.Abstractions;

public interface IWorkspaceRepository
{
    Task AddAsync(Workspace workspace, CancellationToken cancellationToken);

    Task AddMemberAsync(WorkspaceMember member, CancellationToken cancellationToken);

    Task<Workspace?> GetByIdAsync(Guid workspaceId, CancellationToken cancellationToken);

    Task<bool> IsMemberAsync(Guid workspaceId, Guid userId, CancellationToken cancellationToken);

    Task<List<Workspace>> ListForUserAsync(Guid userId, CancellationToken cancellationToken);
}
