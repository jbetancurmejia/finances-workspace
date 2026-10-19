using Microsoft.AspNetCore.Mvc;
using Money.Api.Contracts;
using Money.Application.Services;

namespace Money.Api.Controllers;

[ApiController]
[Route("api/life-cost")]
public sealed class LifeCostController(LifeCostService lifeCostService) : ControllerBase
{
    [HttpPost]
    [ProducesResponseType(typeof(LifeCostResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<LifeCostResponse>> Calculate(
        [FromBody] CalculateLifeCostRequest request,
        CancellationToken cancellationToken)
    {
        var lifeCost = await lifeCostService.CalculateAsync(request.Amount, cancellationToken);

        return Ok(new LifeCostResponse(lifeCost.Hours, lifeCost.Days));
    }
}
