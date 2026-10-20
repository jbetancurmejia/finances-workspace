using Money.Application.Abstractions;
using Money.Application.Cards;
using Money.Domain.Rules;

namespace Money.Application.Services;

public sealed class CardService(IWorkspaceRepository workspaces, ITransactionRepository transactions)
{
    public async Task<IReadOnlyList<CardSummary>> ListForUserAsync(Guid userId, CancellationToken cancellationToken)
    {
        var found = await workspaces.ListForUserAsync(userId, cancellationToken);
        var cards = new List<CardSummary>(found.Count);

        foreach (var workspace in found)
        {
            var (income, expense) = await transactions.GetTotalsAsync(workspace.Id, cancellationToken);
            cards.Add(new CardSummary(
                workspace.Id,
                workspace.Name,
                workspace.OwnerId == userId,
                income - expense,
                CardStatusRule.Evaluate(income, expense)));
        }

        return cards;
    }
}
