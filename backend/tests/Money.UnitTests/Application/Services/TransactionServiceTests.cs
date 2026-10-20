using FluentAssertions;
using Money.Application.Abstractions;
using Money.Application.Services;
using Money.Application.Workspaces;
using Money.Domain.Entities;

namespace Money.UnitTests.Application.Services;

public sealed class TransactionServiceTests
{
    private sealed class FakeWorkspaceRepository(params (Guid workspaceId, Guid userId)[] members) : IWorkspaceRepository
    {
        public Task AddAsync(Workspace workspace, CancellationToken cancellationToken) => Task.CompletedTask;

        public Task AddMemberAsync(WorkspaceMember member, CancellationToken cancellationToken) => Task.CompletedTask;

        public Task<Workspace?> GetByIdAsync(Guid workspaceId, CancellationToken cancellationToken) => Task.FromResult<Workspace?>(null);

        public Task<bool> IsMemberAsync(Guid workspaceId, Guid userId, CancellationToken cancellationToken) =>
            Task.FromResult(members.Contains((workspaceId, userId)));

        public Task<List<Workspace>> ListForUserAsync(Guid userId, CancellationToken cancellationToken) =>
            Task.FromResult(new List<Workspace>());
    }

    private sealed class FakeTransactionRepository : ITransactionRepository
    {
        public List<Transaction> Items { get; } = [];

        public Task AddAsync(Transaction transaction, CancellationToken cancellationToken)
        {
            Items.Add(transaction);
            return Task.CompletedTask;
        }

        public Task<List<Transaction>> ListByWorkspaceAsync(Guid workspaceId, CancellationToken cancellationToken) =>
            Task.FromResult(Items.Where(item => item.WorkspaceId == workspaceId).ToList());

        public Task<(decimal Income, decimal Expense)> GetTotalsAsync(Guid workspaceId, CancellationToken cancellationToken)
        {
            var mine = Items.Where(item => item.WorkspaceId == workspaceId).ToList();
            var income = mine.Where(item => item.Kind == TransactionKind.Income).Sum(item => item.Amount);
            var expense = mine.Where(item => item.Kind == TransactionKind.Expense).Sum(item => item.Amount);
            return Task.FromResult((income, expense));
        }
    }

    private sealed class FakeUnitOfWork : IUnitOfWork
    {
        public Task SaveChangesAsync(CancellationToken cancellationToken) => Task.CompletedTask;
    }

    private static readonly DateOnly Today = DateOnly.FromDateTime(DateTime.Today);

    [Fact]
    public async Task RecordAsync_WhenUserIsMember_StoresTransactionInWorkspace()
    {
        // Arrange
        var workspaceId = Guid.NewGuid();
        var userId = Guid.NewGuid();
        var repository = new FakeTransactionRepository();
        var service = new TransactionService(new FakeWorkspaceRepository((workspaceId, userId)), repository, new FakeUnitOfWork());

        // Act
        var summary = await service.RecordAsync(userId, workspaceId, TransactionKind.Expense, 300_000m, "Mercado", Today, CancellationToken.None);

        // Assert
        summary.Amount.Should().Be(300_000m);
        summary.CreatedByUserId.Should().Be(userId);
        repository.Items.Should().ContainSingle(item => item.WorkspaceId == workspaceId);
    }

    [Fact]
    public async Task RecordAsync_WhenUserIsNotMember_ThrowsWorkspaceNotFoundException()
    {
        // Arrange
        var repository = new FakeTransactionRepository();
        var service = new TransactionService(new FakeWorkspaceRepository(), repository, new FakeUnitOfWork());

        // Act
        var act = () => service.RecordAsync(Guid.NewGuid(), Guid.NewGuid(), TransactionKind.Expense, 10m, "x", Today, CancellationToken.None);

        // Assert
        await act.Should().ThrowAsync<WorkspaceNotFoundException>();
        repository.Items.Should().BeEmpty();
    }

    [Fact]
    public async Task ListAsync_WhenBothPartnersAreMembers_ReturnsTransactionsCreatedByEither()
    {
        // Arrange
        var workspaceId = Guid.NewGuid();
        var owner = Guid.NewGuid();
        var partner = Guid.NewGuid();
        var repository = new FakeTransactionRepository();
        var members = new FakeWorkspaceRepository((workspaceId, owner), (workspaceId, partner));
        var service = new TransactionService(members, repository, new FakeUnitOfWork());
        await service.RecordAsync(owner, workspaceId, TransactionKind.Expense, 10m, "a", Today, CancellationToken.None);
        await service.RecordAsync(partner, workspaceId, TransactionKind.Income, 20m, "b", Today, CancellationToken.None);

        // Act
        var list = await service.ListAsync(partner, workspaceId, CancellationToken.None);

        // Assert
        list.Should().HaveCount(2);
    }
}
