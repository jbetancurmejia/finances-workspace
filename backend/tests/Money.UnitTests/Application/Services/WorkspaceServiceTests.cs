using FluentAssertions;
using Money.Application.Abstractions;
using Money.Application.Services;
using Money.Application.Workspaces;
using Money.Domain.Entities;

namespace Money.UnitTests.Application.Services;

public sealed class WorkspaceServiceTests
{
    private sealed class FakeWorkspaceRepository : IWorkspaceRepository
    {
        public List<Workspace> Workspaces { get; } = [];

        public List<WorkspaceMember> Members { get; } = [];

        public Task AddAsync(Workspace workspace, CancellationToken cancellationToken)
        {
            Workspaces.Add(workspace);
            return Task.CompletedTask;
        }

        public Task AddMemberAsync(WorkspaceMember member, CancellationToken cancellationToken)
        {
            Members.Add(member);
            return Task.CompletedTask;
        }

        public Task<Workspace?> GetByIdAsync(Guid workspaceId, CancellationToken cancellationToken) =>
            Task.FromResult(Workspaces.FirstOrDefault(workspace => workspace.Id == workspaceId));

        public Task<bool> IsMemberAsync(Guid workspaceId, Guid userId, CancellationToken cancellationToken) =>
            Task.FromResult(Members.Any(member => member.WorkspaceId == workspaceId && member.UserId == userId));

        public Task<List<Workspace>> ListForUserAsync(Guid userId, CancellationToken cancellationToken)
        {
            var ids = Members.Where(member => member.UserId == userId).Select(member => member.WorkspaceId).ToHashSet();
            return Task.FromResult(Workspaces.Where(workspace => ids.Contains(workspace.Id)).ToList());
        }
    }

    private sealed class FakeUserRepository : IUserRepository
    {
        public List<User> Users { get; } = [];

        public Task<User?> GetByEmailAsync(string email, CancellationToken cancellationToken) =>
            Task.FromResult(Users.FirstOrDefault(user => user.Email == email));

        public Task AddAsync(User user, CancellationToken cancellationToken)
        {
            Users.Add(user);
            return Task.CompletedTask;
        }
    }

    private sealed class FakeUnitOfWork : IUnitOfWork
    {
        public Task SaveChangesAsync(CancellationToken cancellationToken) => Task.CompletedTask;
    }

    private static (WorkspaceService service, FakeWorkspaceRepository workspaces, FakeUserRepository users) CreateService()
    {
        var workspaces = new FakeWorkspaceRepository();
        var users = new FakeUserRepository();
        var service = new WorkspaceService(workspaces, users, new FakeUnitOfWork());

        return (service, workspaces, users);
    }

    [Fact]
    public async Task CreateAsync_WhenCalled_MakesOwnerAMemberAndReturnsOwnerSummary()
    {
        // Arrange
        var (service, workspaces, _) = CreateService();
        var ownerId = Guid.NewGuid();

        // Act
        var summary = await service.CreateAsync(ownerId, "Gastos de Hogar", CancellationToken.None);

        // Assert
        summary.IsOwner.Should().BeTrue();
        workspaces.Members.Should().ContainSingle(member => member.UserId == ownerId && member.WorkspaceId == summary.Id);
    }

    [Fact]
    public async Task AddMemberAsync_WhenRequesterIsMemberAndEmailExists_AddsPartnerAsSymmetricMember()
    {
        // Arrange
        var (service, workspaces, users) = CreateService();
        var ownerId = Guid.NewGuid();
        var partner = new User("pareja@example.com", "Pareja", "hash");
        users.Users.Add(partner);
        var summary = await service.CreateAsync(ownerId, "Hogar", CancellationToken.None);

        // Act
        await service.AddMemberAsync(ownerId, summary.Id, "Pareja@Example.com", CancellationToken.None);

        // Assert
        workspaces.Members.Should().Contain(member => member.UserId == partner.Id && member.WorkspaceId == summary.Id);
    }

    [Fact]
    public async Task AddMemberAsync_WhenRequesterIsNotMember_ThrowsWorkspaceNotFoundException()
    {
        // Arrange
        var (service, _, users) = CreateService();
        users.Users.Add(new User("pareja@example.com", "Pareja", "hash"));
        var summary = await service.CreateAsync(Guid.NewGuid(), "Hogar", CancellationToken.None);

        // Act
        var act = () => service.AddMemberAsync(Guid.NewGuid(), summary.Id, "pareja@example.com", CancellationToken.None);

        // Assert
        await act.Should().ThrowAsync<WorkspaceNotFoundException>();
    }

    [Fact]
    public async Task AddMemberAsync_WhenEmailIsNotRegistered_ThrowsMemberUserNotFoundException()
    {
        // Arrange
        var (service, _, _) = CreateService();
        var ownerId = Guid.NewGuid();
        var summary = await service.CreateAsync(ownerId, "Hogar", CancellationToken.None);

        // Act
        var act = () => service.AddMemberAsync(ownerId, summary.Id, "nadie@example.com", CancellationToken.None);

        // Assert
        await act.Should().ThrowAsync<MemberUserNotFoundException>();
    }

    [Fact]
    public async Task AddMemberAsync_WhenUserIsAlreadyMember_ThrowsAlreadyMemberException()
    {
        // Arrange
        var (service, _, users) = CreateService();
        var ownerId = Guid.NewGuid();
        users.Users.Add(new User("pareja@example.com", "Pareja", "hash"));
        var summary = await service.CreateAsync(ownerId, "Hogar", CancellationToken.None);
        await service.AddMemberAsync(ownerId, summary.Id, "pareja@example.com", CancellationToken.None);

        // Act
        var act = () => service.AddMemberAsync(ownerId, summary.Id, "pareja@example.com", CancellationToken.None);

        // Assert
        await act.Should().ThrowAsync<AlreadyMemberException>();
    }

    [Fact]
    public async Task ListForUserAsync_WhenUserIsPartner_ReturnsSharedWorkspaceWithIsOwnerFalse()
    {
        // Arrange
        var (service, _, users) = CreateService();
        var ownerId = Guid.NewGuid();
        var partner = new User("pareja@example.com", "Pareja", "hash");
        users.Users.Add(partner);
        var summary = await service.CreateAsync(ownerId, "Hogar", CancellationToken.None);
        await service.AddMemberAsync(ownerId, summary.Id, "pareja@example.com", CancellationToken.None);

        // Act
        var list = await service.ListForUserAsync(partner.Id, CancellationToken.None);

        // Assert
        list.Should().ContainSingle(item => item.Id == summary.Id && !item.IsOwner);
    }
}
