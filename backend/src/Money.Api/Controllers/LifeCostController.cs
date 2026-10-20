using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Money.Api.Contracts;
using Money.Api.Security;
using Money.Application.Services;

namespace Money.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/life-cost")]
public sealed class LifeCostController(LifeCostService lifeCostService) : ControllerBase
{
    [HttpPost]
    [ProducesResponseType(typeof(LifeCostResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<LifeCostResponse>> Calculate(
        [FromBody] CalculateLifeCostRequest request,
        CancellationToken cancellationToken)
    {
        var lifeCost = await lifeCostService.CalculateAsync(User.GetUserId(), request.Amount, cancellationToken);

        return Ok(new LifeCostResponse(lifeCost.Hours, lifeCost.Days));
    }
}
