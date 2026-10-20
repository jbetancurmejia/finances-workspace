import 'package:money_app/features/loans/data/dtos/loan_dto.dart';
import 'package:money_app/features/loans/domain/entities/loan.dart';
import 'package:money_app/features/loans/domain/entities/loan_installment.dart';

extension LoanDtoMapper on LoanDto {
  Loan toEntity() => Loan(
    id: id,
    principalPesos: principal,
    annualEffectiveRatePercent: annualEffectiveRatePercent,
    monthlyRatePercent: monthlyRatePercent,
    termMonths: termMonths,
    startDate: DateTime.parse(startDate),
    fixedMonthlyPaymentPesos: fixedMonthlyPayment,
    installments: installments
        .map(
          (item) => LoanInstallment(
            number: item.number,
            dueDate: DateTime.parse(item.dueDate),
            paymentPesos: item.payment,
            principalPaymentPesos: item.principalPayment,
            interestPaymentPesos: item.interestPayment,
            remainingBalancePesos: item.remainingBalance,
          ),
        )
        .toList(),
  );
}
