using FluentAssertions;
using Money.Infrastructure.Security;

namespace Money.UnitTests.Infrastructure.Security;

public sealed class Pbkdf2PasswordHasherTests
{
    [Fact]
    public void Verify_WhenPasswordMatchesHash_ReturnsTrue()
    {
        // Arrange
        var hasher = new Pbkdf2PasswordHasher();
        var hash = hasher.Hash("secret123");

        // Act
        var result = hasher.Verify("secret123", hash);

        // Assert
        result.Should().BeTrue();
    }

    [Fact]
    public void Verify_WhenPasswordDiffers_ReturnsFalse()
    {
        // Arrange
        var hasher = new Pbkdf2PasswordHasher();
        var hash = hasher.Hash("secret123");

        // Act
        var result = hasher.Verify("other-password", hash);

        // Assert
        result.Should().BeFalse();
    }

    [Fact]
    public void Hash_WhenCalledTwiceWithSamePassword_ProducesDifferentHashes()
    {
        // Arrange
        var hasher = new Pbkdf2PasswordHasher();

        // Act
        var first = hasher.Hash("secret123");
        var second = hasher.Hash("secret123");

        // Assert
        first.Should().NotBe(second);
    }

    [Fact]
    public void Verify_WhenHashIsMalformed_ReturnsFalse()
    {
        // Arrange
        var hasher = new Pbkdf2PasswordHasher();

        // Act
        var result = hasher.Verify("secret123", "not-a-hash");

        // Assert
        result.Should().BeFalse();
    }
}
