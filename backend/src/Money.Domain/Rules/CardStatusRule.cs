namespace Money.Domain.Rules;

public static class CardStatusRule
{
    public const decimal CriticalBalanceRatio = 0.20m;

    public static CardStatus Evaluate(decimal totalIncome, decimal totalExpense)
    {
        var balance = totalIncome - totalExpense;

        if (balance <= 0)
        {
            return CardStatus.Red;
        }

        return balance < totalIncome * CriticalBalanceRatio
            ? CardStatus.Yellow
            : CardStatus.Green;
    }
}
