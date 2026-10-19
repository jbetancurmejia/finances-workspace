using FluentAssertions;
using Money.Domain.Entities;

namespace Money.UnitTests.Domain.Entities;

public sealed class EntityTests
{
    private sealed class FakeEntity : Entity;

    [Fact]
    public void Constructor_WhenCreated_AssignsNonEmptyId()
    {
        // Arrange & Act
        var entity = new FakeEntity();

        // Assert
        entity.Id.Should().NotBeEmpty();
    }

    [Fact]
    public void Constructor_WhenCreatedTwice_AssignsDifferentIds()
    {
        // Arrange & Act
        var first = new FakeEntity();
        var second = new FakeEntity();

        // Assert
        first.Id.Should().NotBe(second.Id);
    }
}
