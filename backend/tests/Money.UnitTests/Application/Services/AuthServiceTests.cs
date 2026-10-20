using FluentAssertions;
using Money.Application.Abstractions;
using Money.Application.Auth;
using Money.Application.Services;
using Money.Domain.Entities;

namespace Money.UnitTests.Application.Services;

public sealed class AuthServiceTests
{
    private sealed class FakeUserRepository : IUserRepository
    {
        public List<User> Users { get; } = [];

        public Task<User?> GetByEmailAsync(string email, CancellationToken cancellationToken)
        {
            return Task.FromResult(Users.FirstOrDefault(user => user.Email == email));
        }

        public Task AddAsync(User user, CancellationToken cancellationToken)
        {
            Users.Add(user);
            return Task.CompletedTask;
        }
    }

    private sealed class FakeProfileRepository : IUserProfileRepository
    {
        public List<UserProfile> Profiles { get; } = [];

        public Task<UserProfile?> GetByUserIdAsync(Guid userId, CancellationToken cancellationToken)
        {
            return Task.FromResult(Profiles.FirstOrDefault(profile => profile.UserId == userId));
        }

        public Task AddAsync(UserProfile profile, CancellationToken cancellationToken)
        {
            Profiles.Add(profile);
            return Task.CompletedTask;
        }
    }

    private sealed class FakeUnitOfWork : IUnitOfWork
    {
        public int SaveCount { get; private set; }

        public Task SaveChangesAsync(CancellationToken cancellationToken)
        {
            SaveCount++;
            return Task.CompletedTask;
        }
    }

    private sealed class FakePasswordHasher : IPasswordHasher
    {
        public string Hash(string password) => $"hashed:{password}";

        public bool Verify(string password, string hash) => hash == $"hashed:{password}";
    }

    private sealed class FakeTokenGenerator : IJwtTokenGenerator
    {
        public string Generate(User user) => $"token-for-{user.Id}";
    }

    private static (AuthService service, FakeUserRepository users, FakeProfileRepository profiles, FakeUnitOfWork unitOfWork)
        CreateService()
    {
        var users = new FakeUserRepository();
        var profiles = new FakeProfileRepository();
        var unitOfWork = new FakeUnitOfWork();
        var service = new AuthService(
            users,
            profiles,
            unitOfWork,
            new FakePasswordHasher(),
            new FakeTokenGenerator());

        return (service, users, profiles, unitOfWork);
    }

    private static RegisterUserCommand ValidCommand(string email = "juan@example.com") =>
        new(email, "secret123", "Juan", 2_000_000m, 160m);

    [Fact]
    public async Task RegisterAsync_WhenEmailIsNew_CreatesUserAndProfileAndReturnsToken()
    {
        // Arrange
        var (service, users, profiles, unitOfWork) = CreateService();

        // Act
        var result = await service.RegisterAsync(ValidCommand(), CancellationToken.None);

        // Assert
        users.Users.Should().ContainSingle();
        profiles.Profiles.Should().ContainSingle(profile => profile.UserId == result.UserId);
        unitOfWork.SaveCount.Should().Be(1);
        result.Token.Should().Be($"token-for-{result.UserId}");
    }

    [Fact]
    public async Task RegisterAsync_WhenEmailExists_ThrowsEmailAlreadyRegisteredException()
    {
        // Arrange
        var (service, _, _, _) = CreateService();
        await service.RegisterAsync(ValidCommand(), CancellationToken.None);

        // Act
        var act = () => service.RegisterAsync(ValidCommand("JUAN@example.com"), CancellationToken.None);

        // Assert
        await act.Should().ThrowAsync<EmailAlreadyRegisteredException>();
    }

    [Fact]
    public async Task LoginAsync_WhenCredentialsAreValid_ReturnsToken()
    {
        // Arrange
        var (service, _, _, _) = CreateService();
        var registered = await service.RegisterAsync(ValidCommand(), CancellationToken.None);

        // Act
        var result = await service.LoginAsync("juan@example.com", "secret123", CancellationToken.None);

        // Assert
        result.UserId.Should().Be(registered.UserId);
        result.Token.Should().Be(registered.Token);
    }

    [Fact]
    public async Task LoginAsync_WhenPasswordIsWrong_ThrowsInvalidCredentialsException()
    {
        // Arrange
        var (service, _, _, _) = CreateService();
        await service.RegisterAsync(ValidCommand(), CancellationToken.None);

        // Act
        var act = () => service.LoginAsync("juan@example.com", "wrong", CancellationToken.None);

        // Assert
        await act.Should().ThrowAsync<InvalidCredentialsException>();
    }

    [Fact]
    public async Task LoginAsync_WhenEmailIsUnknown_ThrowsInvalidCredentialsException()
    {
        // Arrange
        var (service, _, _, _) = CreateService();

        // Act
        var act = () => service.LoginAsync("nobody@example.com", "secret123", CancellationToken.None);

        // Assert
        await act.Should().ThrowAsync<InvalidCredentialsException>();
    }
}
