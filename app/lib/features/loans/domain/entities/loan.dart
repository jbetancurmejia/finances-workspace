import 'package:equatable/equatable.dart';
import 'package:money_app/features/loans/domain/entities/loan_installment.dart';

final class Loan extends Equatable {
  const Loan({
    required this.id,
    required this.principalPesos,
    required this.annualEffectiveRatePercent,
    required this.monthlyRatePercent,
    required this.termMonths,
    required this.startDate,
    required this.fixedMonthlyPaymentPesos,
    required this.installments,
  });

  final String id;
  final int principalPesos;
  final double annualEffectiveRatePercent;
  final double monthlyRatePercent;
  final int termMonths;
  final DateTime startDate;
  final int fixedMonthlyPaymentPesos;
  final List<LoanInstallment> installments;

  @override
  List<Object?> get props => [
    id,
    principalPesos,
    annualEffectiveRatePercent,
    monthlyRatePercent,
    termMonths,
    startDate,
    fixedMonthlyPaymentPesos,
    installments,
  ];
}
