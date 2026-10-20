using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Money.Api.Contracts;
using Money.Api.Security;
using Money.Application.Cards;
using Money.Application.Services;
using Money.Application.Workspaces;

namespace Money.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/workspaces")]
public sealed class WorkspacesController(WorkspaceService workspaceService, CardService cardService) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(typeof(IReadOnlyList<WorkspaceResponse>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyList<WorkspaceResponse>>> List(CancellationToken cancellationToken)
    {
        var workspaces = await workspaceService.ListForUserAsync(User.GetUserId(), cancellationToken);

        return Ok(workspaces.Select(ToResponse).ToList());
    }

    [HttpGet("cards")]
    [ProducesResponseType(typeof(IReadOnlyList<CardResponse>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyList<CardResponse>>> ListCards(CancellationToken cancellationToken)
    {
        var cards = await cardService.ListForUserAsync(User.GetUserId(), cancellationToken);

        return Ok(cards.Select(ToCardResponse).ToList());
    }

    [HttpPost]
    [ProducesResponseType(typeof(WorkspaceResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<WorkspaceResponse>> Create(
        [FromBody] CreateWorkspaceRequest request,
        CancellationToken cancellationToken)
    {
        var workspace = await workspaceService.CreateAsync(User.GetUserId(), request.Name, cancellationToken);

        return StatusCode(StatusCodes.Status201Created, ToResponse(workspace));
    }

    [HttpPost("{workspaceId:guid}/members")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> AddMember(
        Guid workspaceId,
        [FromBody] AddMemberRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            await workspaceService.AddMemberAsync(User.GetUserId(), workspaceId, request.Email, cancellationToken);

            return NoContent();
        }
        catch (WorkspaceNotFoundException)
        {
            return NotFound();
        }
        catch (MemberUserNotFoundException)
        {
            return NotFound();
        }
        catch (AlreadyMemberException)
        {
            return Conflict();
        }
    }

    private static CardResponse ToCardResponse(CardSummary card) =>
        new(card.Id, card.Name, card.IsOwner, decimal.ToInt64(card.Balance), card.Status.ToString());

    private static WorkspaceResponse ToResponse(WorkspaceSummary summary) =>
        new(summary.Id, summary.Name, summary.IsOwner);
}
