using Microsoft.EntityFrameworkCore;
using Money.Application.Abstractions;
using Money.Domain.Loans;

namespace Money.Infrastructure.Persistence.Repositories;

public sealed class LoanRepository(MoneyDbContext context) : ILoanRepository
{
    public async Task AddAsync(Loan loan, CancellationToken cancellationToken)
    {
        await context.Loans.AddAsync(loan, cancellationToken);
    }

    public async Task<List<Loan>> ListForUserAsync(Guid userId, CancellationToken cancellationToken)
    {
        return await context.Loans
            .AsNoTracking()
            .Where(loan => loan.UserId == userId)
            .OrderByDescending(loan => loan.StartDate)
            .ToListAsync(cancellationToken);
    }
}
