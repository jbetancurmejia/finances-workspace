using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Money.Domain.Entities;

namespace Money.Infrastructure.Persistence.Configurations;

public sealed class UserProfileConfiguration : IEntityTypeConfiguration<UserProfile>
{
    public void Configure(EntityTypeBuilder<UserProfile> builder)
    {
        builder.ToTable("UserProfiles");
        builder.HasKey(profile => profile.Id);
        builder.Property(profile => profile.MonthlySalary).HasPrecision(18, 2);
        builder.Property(profile => profile.MonthlyWorkHours).HasPrecision(18, 2);
        builder.HasIndex(profile => profile.UserId).IsUnique();
    }
}
