import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/features/loans/data/dtos/loan_dto.dart';
import 'package:money_app/features/loans/data/mappers/loan_mapper.dart';

void main() {
  group('LoanDto', () {
    test('parses loan and installment fields and maps to domain', () {
      // Arrange
      final json = <String, dynamic>{
        'id': 'l1',
        'principal': 1000000,
        'annualEffectiveRatePercent': 20,
        'monthlyRatePercent': 1.530947,
        'termMonths': 1,
        'startDate': '2026-01-31',
        'fixedMonthlyPayment': 91857,
        'installments': [
          {
            'number': 1,
            'dueDate': '2026-02-28',
            'payment': 91857.12,
            'principalPayment': 76547.65,
            'interestPayment': 15309.47,
            'remainingBalance': 923452.35,
          },
        ],
      };

      // Act
      final loan = LoanDto.fromJson(json).toEntity();

      // Assert
      expect(loan.principalPesos, 1000000);
      expect(loan.monthlyRatePercent, closeTo(1.530947, 0.000001));
      expect(loan.installments.single.paymentPesos, 91857);
      expect(loan.installments.single.dueDate, DateTime(2026, 2, 28));
    });
  });
}
