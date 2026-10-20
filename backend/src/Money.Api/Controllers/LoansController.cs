using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Money.Api.Contracts;
using Money.Api.Security;
using Money.Application.Loans;
using Money.Application.Services;
using Money.Domain.Loans;

namespace Money.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/loans")]
public sealed class LoansController(LoanService loanService) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(typeof(IReadOnlyList<LoanResponse>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyList<LoanResponse>>> List(CancellationToken cancellationToken)
    {
        var loans = await loanService.ListForUserAsync(User.GetUserId(), cancellationToken);

        return Ok(loans.Select(ToResponse).ToList());
    }

    [HttpPost]
    [ProducesResponseType(typeof(LoanResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<LoanResponse>> Create(
        [FromBody] CreateLoanRequest request,
        CancellationToken cancellationToken)
    {
        if (request.StartDate == default)
        {
            return BadRequest();
        }

        var summary = await loanService.CreateAsync(
            User.GetUserId(),
            request.Principal,
            request.AnnualEffectiveRatePercent,
            request.TermMonths,
            request.StartDate,
            cancellationToken);

        var response = ToResponse(summary);

        return StatusCode(StatusCodes.Status201Created, response);
    }

    private static LoanResponse ToResponse(LoanSummary summary)
    {
        var loan = summary.Loan;
        var monthlyRate = LoanAmortizationCalculator.ConvertAnnualEffectiveToMonthly(
            loan.AnnualEffectiveRatePercent);
        var installments = summary.Installments
            .Select(item => new LoanInstallmentResponse(
                item.Number,
                item.DueDate,
                item.Payment,
                item.PrincipalPayment,
                item.InterestPayment,
                item.RemainingBalance))
            .ToList();

        return new LoanResponse(
            loan.Id,
            decimal.ToInt64(loan.Principal),
            loan.AnnualEffectiveRatePercent,
            monthlyRate * 100m,
            loan.TermMonths,
            loan.StartDate,
            installments[0].Payment,
            installments);
    }
}
