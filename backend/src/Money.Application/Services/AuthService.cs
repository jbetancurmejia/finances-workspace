using Money.Application.Abstractions;
using Money.Application.Auth;
using Money.Domain.Entities;

namespace Money.Application.Services;

public sealed class AuthService(
    IUserRepository users,
    IUserProfileRepository profiles,
    IUnitOfWork unitOfWork,
    IPasswordHasher passwordHasher,
    IJwtTokenGenerator tokenGenerator)
{
    public async Task<AuthResult> RegisterAsync(RegisterUserCommand command, CancellationToken cancellationToken)
    {
        var normalizedEmail = command.Email.Trim().ToLowerInvariant();

        if (await users.GetByEmailAsync(normalizedEmail, cancellationToken) is not null)
        {
            throw new EmailAlreadyRegisteredException(normalizedEmail);
        }

        var user = new User(normalizedEmail, command.DisplayName, passwordHasher.Hash(command.Password));
        var profile = new UserProfile(user.Id, command.MonthlySalary, command.MonthlyWorkHours);

        await users.AddAsync(user, cancellationToken);
        await profiles.AddAsync(profile, cancellationToken);
        await unitOfWork.SaveChangesAsync(cancellationToken);

        return new AuthResult(tokenGenerator.Generate(user), user.Id, user.DisplayName);
    }

    public async Task<AuthResult> LoginAsync(string email, string password, CancellationToken cancellationToken)
    {
        var user = await users.GetByEmailAsync(email.Trim().ToLowerInvariant(), cancellationToken);

        if (user is null || !passwordHasher.Verify(password, user.PasswordHash))
        {
            throw new InvalidCredentialsException();
        }

        return new AuthResult(tokenGenerator.Generate(user), user.Id, user.DisplayName);
    }
}
