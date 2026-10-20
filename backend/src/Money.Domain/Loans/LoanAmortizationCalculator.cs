namespace Money.Domain.Loans;

public static class LoanAmortizationCalculator
{
    public static decimal ConvertAnnualEffectiveToMonthly(decimal annualEffectiveRatePercent)
    {
        if (annualEffectiveRatePercent < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(annualEffectiveRatePercent));
        }

        var annualRate = (double)(annualEffectiveRatePercent / 100m);
        var monthlyRate = Math.Pow(1d + annualRate, 1d / 12d) - 1d;

        return (decimal)monthlyRate;
    }

    public static IReadOnlyList<LoanInstallment> GenerateSchedule(Loan loan)
    {
        var monthlyRate = ConvertAnnualEffectiveToMonthly(loan.AnnualEffectiveRatePercent);
        var payment = CalculateMonthlyPayment(loan.Principal, monthlyRate, loan.TermMonths);
        var balance = loan.Principal;
        var schedule = new List<LoanInstallment>(loan.TermMonths);

        for (var month = 1; month <= loan.TermMonths; month++)
        {
            var interest = decimal.Round(balance * monthlyRate, 2, MidpointRounding.AwayFromZero);
            var principal = month == loan.TermMonths
                ? balance
                : decimal.Min(balance, payment - interest);
            var installmentPayment = principal + interest;
            balance = decimal.Max(0m, balance - principal);
            var dueDate = loan.StartDate.AddMonths(month);

            schedule.Add(new LoanInstallment(
                month,
                dueDate,
                installmentPayment,
                principal,
                interest,
                balance));
        }

        return schedule;
    }

    private static decimal CalculateMonthlyPayment(decimal principal, decimal monthlyRate, int termMonths)
    {
        if (monthlyRate == 0m)
        {
            return decimal.Round(principal / termMonths, 2, MidpointRounding.AwayFromZero);
        }

        var rate = (double)monthlyRate;
        var payment = (double)principal * rate / (1d - Math.Pow(1d + rate, -termMonths));

        return decimal.Round((decimal)payment, 2, MidpointRounding.AwayFromZero);
    }
}
