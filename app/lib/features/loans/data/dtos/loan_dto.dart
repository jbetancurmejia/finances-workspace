import 'package:money_app/features/loans/data/dtos/loan_installment_dto.dart';

final class LoanDto {
  const LoanDto({
    required this.id,
    required this.principal,
    required this.annualEffectiveRatePercent,
    required this.monthlyRatePercent,
    required this.termMonths,
    required this.startDate,
    required this.fixedMonthlyPayment,
    required this.installments,
  });

  factory LoanDto.fromJson(Map<String, dynamic> json) {
    return LoanDto(
      id: json['id'] as String,
      principal: (json['principal'] as num).toInt(),
      annualEffectiveRatePercent: (json['annualEffectiveRatePercent'] as num)
          .toDouble(),
      monthlyRatePercent: (json['monthlyRatePercent'] as num).toDouble(),
      termMonths: (json['termMonths'] as num).toInt(),
      startDate: json['startDate'] as String,
      fixedMonthlyPayment: (json['fixedMonthlyPayment'] as num).round(),
      installments: (json['installments'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(LoanInstallmentDto.fromJson)
          .toList(),
    );
  }

  final String id;
  final int principal;
  final double annualEffectiveRatePercent;
  final double monthlyRatePercent;
  final int termMonths;
  final String startDate;
  final int fixedMonthlyPayment;
  final List<LoanInstallmentDto> installments;
}
