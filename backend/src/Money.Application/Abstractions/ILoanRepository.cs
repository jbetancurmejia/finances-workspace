using Money.Domain.Loans;

namespace Money.Application.Abstractions;

public interface ILoanRepository
{
    Task AddAsync(Loan loan, CancellationToken cancellationToken);

    Task<List<Loan>> ListForUserAsync(Guid userId, CancellationToken cancellationToken);
}
