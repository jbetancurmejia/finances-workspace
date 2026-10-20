using Money.Application.Abstractions;
using Money.Application.Workspaces;
using Money.Domain.Entities;

namespace Money.Application.Services;

public sealed class WorkspaceService(
    IWorkspaceRepository workspaces,
    IUserRepository users,
    IUnitOfWork unitOfWork)
{
    public async Task<WorkspaceSummary> CreateAsync(Guid ownerId, string name, CancellationToken cancellationToken)
    {
        var workspace = new Workspace(name, ownerId);
        var owner = new WorkspaceMember(workspace.Id, ownerId);

        await workspaces.AddAsync(workspace, cancellationToken);
        await workspaces.AddMemberAsync(owner, cancellationToken);
        await unitOfWork.SaveChangesAsync(cancellationToken);

        return new WorkspaceSummary(workspace.Id, workspace.Name, IsOwner: true);
    }

    public async Task<IReadOnlyList<WorkspaceSummary>> ListForUserAsync(Guid userId, CancellationToken cancellationToken)
    {
        var found = await workspaces.ListForUserAsync(userId, cancellationToken);

        return found
            .Select(workspace => new WorkspaceSummary(workspace.Id, workspace.Name, workspace.OwnerId == userId))
            .ToList();
    }

    public async Task AddMemberAsync(
        Guid requesterId,
        Guid workspaceId,
        string memberEmail,
        CancellationToken cancellationToken)
    {
        await EnsureMemberAsync(requesterId, workspaceId, cancellationToken);

        var member = await users.GetByEmailAsync(memberEmail.Trim().ToLowerInvariant(), cancellationToken)
            ?? throw new MemberUserNotFoundException(memberEmail);

        if (await workspaces.IsMemberAsync(workspaceId, member.Id, cancellationToken))
        {
            throw new AlreadyMemberException(memberEmail);
        }

        await workspaces.AddMemberAsync(new WorkspaceMember(workspaceId, member.Id), cancellationToken);
        await unitOfWork.SaveChangesAsync(cancellationToken);
    }

    private async Task EnsureMemberAsync(Guid userId, Guid workspaceId, CancellationToken cancellationToken)
    {
        if (!await workspaces.IsMemberAsync(workspaceId, userId, cancellationToken))
        {
            throw new WorkspaceNotFoundException(workspaceId);
        }
    }
}
