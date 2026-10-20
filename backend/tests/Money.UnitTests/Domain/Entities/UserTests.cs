using FluentAssertions;
using Money.Domain.Entities;

namespace Money.UnitTests.Domain.Entities;

public sealed class UserTests
{
    [Fact]
    public void Constructor_WhenEmailHasSpacesAndUppercase_NormalizesEmail()
    {
        // Arrange & Act
        var user = new User("  Juan@Example.COM ", "Juan", "hash");

        // Assert
        user.Email.Should().Be("juan@example.com");
    }

    [Fact]
    public void Constructor_WhenEmailIsBlank_ThrowsArgumentException()
    {
        // Arrange & Act
        var act = () => new User("   ", "Juan", "hash");

        // Assert
        act.Should().Throw<ArgumentException>().WithParameterName("email");
    }
}
