namespace Money.Domain.Entities;

public sealed class WorkspaceMember : Entity
{
    private WorkspaceMember()
    {
    }

    public WorkspaceMember(Guid workspaceId, Guid userId)
    {
        WorkspaceId = workspaceId;
        UserId = userId;
    }

    public Guid WorkspaceId { get; private set; }

    public Guid UserId { get; private set; }
}
