using Microsoft.AspNetCore.Mvc;
using Money.Api.Contracts;
using Money.Application.Auth;
using Money.Application.Services;

namespace Money.Api.Controllers;

[ApiController]
[Route("api/auth")]
public sealed class AuthController(AuthService authService) : ControllerBase
{
    [HttpPost("register")]
    [ProducesResponseType(typeof(AuthResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<ActionResult<AuthResponse>> Register(
        [FromBody] RegisterRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await authService.RegisterAsync(
                new RegisterUserCommand(
                    request.Email,
                    request.Password,
                    request.DisplayName,
                    request.MonthlySalary,
                    request.MonthlyWorkHours),
                cancellationToken);

            return StatusCode(StatusCodes.Status201Created, ToResponse(result));
        }
        catch (EmailAlreadyRegisteredException)
        {
            return Conflict();
        }
    }

    [HttpPost("login")]
    [ProducesResponseType(typeof(AuthResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<AuthResponse>> Login(
        [FromBody] LoginRequest request,
        CancellationToken cancellationToken)
    {
        try
        {
            var result = await authService.LoginAsync(request.Email, request.Password, cancellationToken);

            return Ok(ToResponse(result));
        }
        catch (InvalidCredentialsException)
        {
            return Unauthorized();
        }
    }

    private static AuthResponse ToResponse(AuthResult result) =>
        new(result.Token, result.UserId, result.DisplayName);
}
