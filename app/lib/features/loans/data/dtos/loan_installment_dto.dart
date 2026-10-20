final class LoanInstallmentDto {
  const LoanInstallmentDto({
    required this.number,
    required this.dueDate,
    required this.payment,
    required this.principalPayment,
    required this.interestPayment,
    required this.remainingBalance,
  });

  factory LoanInstallmentDto.fromJson(Map<String, dynamic> json) {
    return LoanInstallmentDto(
      number: (json['number'] as num).toInt(),
      dueDate: json['dueDate'] as String,
      payment: (json['payment'] as num).round(),
      principalPayment: (json['principalPayment'] as num).round(),
      interestPayment: (json['interestPayment'] as num).round(),
      remainingBalance: (json['remainingBalance'] as num).round(),
    );
  }

  final int number;
  final String dueDate;
  final int payment;
  final int principalPayment;
  final int interestPayment;
  final int remainingBalance;
}
