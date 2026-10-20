namespace Money.Domain.Entities;

public sealed class Workspace : Entity
{
    private Workspace()
    {
    }

    public Workspace(string name, Guid ownerId)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(name);

        Name = name.Trim();
        OwnerId = ownerId;
    }

    public string Name { get; private set; } = string.Empty;

    public Guid OwnerId { get; private set; }
}
