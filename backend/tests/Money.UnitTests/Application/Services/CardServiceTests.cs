using FluentAssertions;
using Money.Application.Abstractions;
using Money.Application.Services;
using Money.Domain.Entities;
using Money.Domain.Rules;

namespace Money.UnitTests.Application.Services;

public sealed class CardServiceTests
{
    private sealed class FakeWorkspaces(params Workspace[] items) : IWorkspaceRepository
    {
        public Task AddAsync(Workspace workspace, CancellationToken cancellationToken) => Task.CompletedTask;

        public Task AddMemberAsync(WorkspaceMember member, CancellationToken cancellationToken) => Task.CompletedTask;

        public Task<Workspace?> GetByIdAsync(Guid workspaceId, CancellationToken cancellationToken) =>
            Task.FromResult(items.FirstOrDefault(item => item.Id == workspaceId));

        public Task<bool> IsMemberAsync(Guid workspaceId, Guid userId, CancellationToken cancellationToken) =>
            Task.FromResult(false);

        public Task<List<Workspace>> ListForUserAsync(Guid userId, CancellationToken cancellationToken) =>
            Task.FromResult(items.ToList());
    }

    private sealed class FakeTransactions(Dictionary<Guid, (decimal Income, decimal Expense)> totals) : ITransactionRepository
    {
        public Task AddAsync(Transaction transaction, CancellationToken cancellationToken) => Task.CompletedTask;

        public Task<List<Transaction>> ListByWorkspaceAsync(Guid workspaceId, CancellationToken cancellationToken) =>
            Task.FromResult(new List<Transaction>());

        public Task<(decimal Income, decimal Expense)> GetTotalsAsync(Guid workspaceId, CancellationToken cancellationToken) =>
            Task.FromResult(totals.GetValueOrDefault(workspaceId));
    }

    [Fact]
    public async Task ListForUserAsync_WhenWorkspaceHasNoMovements_ReturnsRedCardWithZeroBalance()
    {
        // Arrange
        var userId = Guid.NewGuid();
        var workspace = new Workspace("Hogar", userId);
        var service = new CardService(new FakeWorkspaces(workspace), new FakeTransactions([]));

        // Act
        var cards = await service.ListForUserAsync(userId, CancellationToken.None);

        // Assert
        cards.Should().ContainSingle(card =>
            card.Balance == 0m && card.Status == CardStatus.Red && card.IsOwner);
    }

    [Fact]
    public async Task ListForUserAsync_ComputesBalanceAndStatusFromTotals()
    {
        // Arrange
        var userId = Guid.NewGuid();
        var workspace = new Workspace("Hogar", userId);
        var totals = new Dictionary<Guid, (decimal Income, decimal Expense)>
        {
            [workspace.Id] = (2_000_000m, 300_000m)
        };
        var service = new CardService(new FakeWorkspaces(workspace), new FakeTransactions(totals));

        // Act
        var cards = await service.ListForUserAsync(userId, CancellationToken.None);

        // Assert
        cards.Should().ContainSingle(card =>
            card.Balance == 1_700_000m && card.Status == CardStatus.Green);
    }
}
