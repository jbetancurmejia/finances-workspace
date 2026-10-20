import 'package:equatable/equatable.dart';

final class LoanInstallment extends Equatable {
  const LoanInstallment({
    required this.number,
    required this.dueDate,
    required this.paymentPesos,
    required this.principalPaymentPesos,
    required this.interestPaymentPesos,
    required this.remainingBalancePesos,
  });

  final int number;
  final DateTime dueDate;
  final int paymentPesos;
  final int principalPaymentPesos;
  final int interestPaymentPesos;
  final int remainingBalancePesos;

  @override
  List<Object?> get props => [
    number,
    dueDate,
    paymentPesos,
    principalPaymentPesos,
    interestPaymentPesos,
    remainingBalancePesos,
  ];
}
