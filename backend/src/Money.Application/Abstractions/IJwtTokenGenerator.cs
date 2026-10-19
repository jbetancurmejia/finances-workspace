using Money.Domain.Entities;

namespace Money.Application.Abstractions;

public interface IJwtTokenGenerator
{
    string Generate(User user);
}
