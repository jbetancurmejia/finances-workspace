using FluentAssertions;
using Money.Domain.Entities;

namespace Money.UnitTests.Domain.Entities;

public sealed class WorkspaceTests
{
    [Fact]
    public void Constructor_WhenNameHasSpaces_TrimsName()
    {
        // Arrange & Act
        var workspace = new Workspace("  Gastos de Hogar  ", Guid.NewGuid());

        // Assert
        workspace.Name.Should().Be("Gastos de Hogar");
    }

    [Fact]
    public void Constructor_WhenNameIsBlank_ThrowsArgumentException()
    {
        // Arrange & Act
        var act = () => new Workspace("   ", Guid.NewGuid());

        // Assert
        act.Should().Throw<ArgumentException>().WithParameterName("name");
    }
}
