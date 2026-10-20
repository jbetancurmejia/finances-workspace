using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Money.Domain.Entities;

namespace Money.Infrastructure.Persistence.Configurations;

public sealed class WorkspaceMemberConfiguration : IEntityTypeConfiguration<WorkspaceMember>
{
    public void Configure(EntityTypeBuilder<WorkspaceMember> builder)
    {
        builder.ToTable("WorkspaceMembers");
        builder.HasKey(member => member.Id);
        builder.HasIndex(member => new { member.WorkspaceId, member.UserId }).IsUnique();
        builder.HasIndex(member => member.UserId);
    }
}
