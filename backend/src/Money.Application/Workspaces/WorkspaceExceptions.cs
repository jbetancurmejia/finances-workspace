namespace Money.Application.Workspaces;

public sealed class WorkspaceNotFoundException(Guid workspaceId)
    : Exception($"Workspace '{workspaceId}' was not found.");

public sealed class MemberUserNotFoundException(string email)
    : Exception($"No user is registered with email '{email}'.");

public sealed class AlreadyMemberException(string email)
    : Exception($"The user '{email}' is already a member of this workspace.");
