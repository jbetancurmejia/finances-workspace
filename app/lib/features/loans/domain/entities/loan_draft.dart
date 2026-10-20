import 'package:equatable/equatable.dart';

final class LoanDraft extends Equatable {
  const LoanDraft({
    required this.principalPesos,
    required this.annualEffectiveRatePercent,
    required this.termMonths,
    required this.startDate,
  });

  final int principalPesos;
  final double annualEffectiveRatePercent;
  final int termMonths;
  final DateTime startDate;

  @override
  List<Object?> get props => [
    principalPesos,
    annualEffectiveRatePercent,
    termMonths,
    startDate,
  ];
}
