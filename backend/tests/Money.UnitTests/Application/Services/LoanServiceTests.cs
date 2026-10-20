using FluentAssertions;
using Money.Application.Abstractions;
using Money.Application.Services;
using Money.Domain.Loans;

namespace Money.UnitTests.Application.Services;

public sealed class LoanServiceTests
{
    private sealed class FakeLoanRepository : ILoanRepository
    {
        public List<Loan> Loans { get; } = [];

        public Task AddAsync(Loan loan, CancellationToken cancellationToken)
        {
            Loans.Add(loan);
            return Task.CompletedTask;
        }

        public Task<List<Loan>> ListForUserAsync(Guid userId, CancellationToken cancellationToken) =>
            Task.FromResult(Loans.Where(loan => loan.UserId == userId).ToList());
    }

    private sealed class FakeUnitOfWork : IUnitOfWork
    {
        public int Saves { get; private set; }

        public Task SaveChangesAsync(CancellationToken cancellationToken)
        {
            Saves++;
            return Task.CompletedTask;
        }
    }

    [Fact]
    public async Task CreateAsync_WhenCalled_PersistsLoanAndReturnsSchedule()
    {
        // Arrange
        var userId = Guid.NewGuid();
        var repository = new FakeLoanRepository();
        var unitOfWork = new FakeUnitOfWork();
        var service = new LoanService(repository, unitOfWork);

        // Act
        var summary = await service.CreateAsync(
            userId,
            1_000_000m,
            20m,
            12,
            new DateOnly(2026, 1, 31),
            CancellationToken.None);

        // Assert
        repository.Loans.Should().ContainSingle(loan => loan.UserId == userId);
        unitOfWork.Saves.Should().Be(1);
        summary.Installments.Should().HaveCount(12);
        summary.Installments[^1].RemainingBalance.Should().Be(0m);
    }

    [Fact]
    public async Task ListForUserAsync_ReturnsOnlyLoansBelongingToUser()
    {
        // Arrange
        var userId = Guid.NewGuid();
        var repository = new FakeLoanRepository();
        repository.Loans.Add(new Loan(userId, 1_000_000m, 20m, 12, new DateOnly(2026, 1, 1)));
        repository.Loans.Add(new Loan(Guid.NewGuid(), 500_000m, 10m, 6, new DateOnly(2026, 1, 1)));
        var service = new LoanService(repository, new FakeUnitOfWork());

        // Act
        var summaries = await service.ListForUserAsync(userId, CancellationToken.None);

        // Assert
        summaries.Should().ContainSingle(summary => summary.Loan.UserId == userId);
        summaries[0].Installments.Should().HaveCount(12);
    }
}
