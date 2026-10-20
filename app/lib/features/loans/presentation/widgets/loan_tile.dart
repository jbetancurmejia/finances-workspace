import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:money_app/features/loans/domain/entities/loan.dart';

final class LoanTile extends StatelessWidget {
  const LoanTile({required this.loan, super.key});

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: r'$',
      decimalDigits: 0,
    );
    final rate = NumberFormat('##0.00', 'es').format(loan.monthlyRatePercent);

    return Card(
      child: ExpansionTile(
        title: Text(currency.format(loan.principalPesos)),
        subtitle: Text(
          'loans.summary'.tr(
            namedArgs: {
              'rate': rate,
              'months': loan.termMonths.toString(),
              'payment': currency.format(loan.fixedMonthlyPaymentPesos),
            },
          ),
        ),
        children: [
          for (final installment in loan.installments)
            ListTile(
              dense: true,
              leading: Text(installment.number.toString()),
              title: Text(
                'loans.installment'.tr(
                  namedArgs: {
                    'date': DateFormat(
                      'yyyy-MM-dd',
                    ).format(installment.dueDate),
                    'payment': currency.format(installment.paymentPesos),
                  },
                ),
              ),
              subtitle: Text(
                'loans.breakdown'.tr(
                  namedArgs: {
                    'principal': currency.format(
                      installment.principalPaymentPesos,
                    ),
                    'interest': currency.format(
                      installment.interestPaymentPesos,
                    ),
                    'balance': currency.format(
                      installment.remainingBalancePesos,
                    ),
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
