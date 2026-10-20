using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Money.Api.Contracts;
using Money.Api.Security;
using Money.Application.Services;
using Money.Application.Transactions;
using Money.Application.Workspaces;

namespace Money.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/workspaces/{workspaceId:guid}/transactions")]
public sealed class TransactionsController(TransactionService transactionService) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(typeof(IReadOnlyList<TransactionResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<IReadOnlyList<TransactionResponse>>> List(
        Guid workspaceId,
        CancellationToken cancellationToken)
    {
        try
        {
            var items = await transactionService.ListAsync(User.GetUserId(), workspaceId, cancellationToken);

            return Ok(items.Select(ToResponse).ToList());
        }
        catch (WorkspaceNotFoundException)
        {
            return NotFound();
        }
    }

    [HttpPost]
    [ProducesResponseType(typeof(TransactionResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<TransactionResponse>> Record(
        Guid workspaceId,
        [FromBody] RecordTransactionRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var created = await transactionService.RecordAsync(
                User.GetUserId(),
                workspaceId,
                request.Kind,
                request.Amount,
                request.Description,
                request.OccurredOn,
                cancellationToken);

            return StatusCode(StatusCodes.Status201Created, ToResponse(created));
        }
        catch (WorkspaceNotFoundException)
        {
            return NotFound();
        }
    }

    private static TransactionResponse ToResponse(TransactionSummary summary) => new(
        summary.Id,
        summary.Kind.ToString(),
        decimal.ToInt64(summary.Amount),
        summary.Description,
        summary.OccurredOn,
        summary.CreatedByUserId);
}
