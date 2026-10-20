using System.ComponentModel.DataAnnotations;

namespace Money.Api.Contracts;

public sealed class CreateWorkspaceRequest
{
    [Required, StringLength(120, MinimumLength = 1)]
    public string Name { get; init; } = string.Empty;
}

public sealed class AddMemberRequest
{
    [Required, EmailAddress, StringLength(256)]
    public string Email { get; init; } = string.Empty;
}

public sealed record WorkspaceResponse(Guid Id, string Name, bool IsOwner);
