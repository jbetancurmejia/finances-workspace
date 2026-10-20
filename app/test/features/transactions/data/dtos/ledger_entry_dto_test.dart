import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/features/transactions/data/dtos/ledger_entry_dto.dart';
import 'package:money_app/features/transactions/data/mappers/ledger_entry_mapper.dart';
import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';

void main() {
  group('LedgerEntryDto', () {
    test('parses an expense from json with integer amount', () {
      // Arrange
      final json = <String, dynamic>{
        'id': 'e1',
        'kind': 'Expense',
        'amount': 300000,
        'description': 'Mercado',
        'occurredOn': '2026-10-18',
        'createdByUserId': 'u1',
      };

      // Act
      final entry = LedgerEntryDto.fromJson(json).toEntity();

      // Assert
      expect(entry.kind, LedgerEntryKind.expense);
      expect(entry.pesos, 300000);
      expect(entry.occurredOn, DateTime(2026, 10, 18));
    });

    test('maps Income kind and decimal amounts to rounded pesos', () {
      // Arrange
      final json = <String, dynamic>{
        'id': 'e2',
        'kind': 'Income',
        'amount': 1500000.0,
        'description': 'Salario',
        'occurredOn': '2026-10-15',
        'createdByUserId': 'u2',
      };

      // Act
      final entry = LedgerEntryDto.fromJson(json).toEntity();

      // Assert
      expect(entry.kind, LedgerEntryKind.income);
      expect(entry.pesos, 1500000);
    });

    test('formats dates as yyyy-MM-dd for the request', () {
      // Arrange
      final date = DateTime(2026, 1, 5);

      // Act
      final formatted = LedgerEntryDto.formatDate(date);

      // Assert
      expect(formatted, '2026-01-05');
    });
  });
}
