import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';
import 'package:money_app/features/transactions/domain/entities/record_entry_params.dart';
import 'package:money_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:money_app/features/transactions/domain/use_cases/record_entry_use_case.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockTransactionRepository repository;
  late RecordEntryUseCase useCase;
  final occurredOn = DateTime(2026, 10, 18);

  setUpAll(() {
    registerFallbackValue(
      RecordEntryParams(
        workspaceId: '',
        kind: LedgerEntryKind.expense,
        pesos: 1,
        description: '',
        occurredOn: occurredOn,
      ),
    );
  });

  setUp(() {
    repository = MockTransactionRepository();
    useCase = RecordEntryUseCase(repository);
  });

  group('RecordEntryUseCase', () {
    test('trims the description before delegating to the repository', () async {
      // Arrange
      final entry = LedgerEntry(
        id: 'e1',
        kind: LedgerEntryKind.expense,
        pesos: 300000,
        description: 'Mercado',
        occurredOn: occurredOn,
        createdByUserId: 'u1',
      );
      when(() => repository.recordEntry(any())).thenAnswer((_) async => entry);

      // Act
      final result = await useCase(
        RecordEntryParams(
          workspaceId: 'w1',
          kind: LedgerEntryKind.expense,
          pesos: 300000,
          description: '  Mercado  ',
          occurredOn: occurredOn,
        ),
      );

      // Assert
      expect(result, entry);
      verify(() => repository.recordEntry(
            RecordEntryParams(
              workspaceId: 'w1',
              kind: LedgerEntryKind.expense,
              pesos: 300000,
              description: 'Mercado',
              occurredOn: occurredOn,
            ),
          )).called(1);
    });

    test('throws ValidationFailure without calling the repository when amount is zero', () async {
      // Arrange
      final params = RecordEntryParams(
        workspaceId: 'w1',
        kind: LedgerEntryKind.expense,
        pesos: 0,
        description: 'Mercado',
        occurredOn: occurredOn,
      );

      // Act
      final call = useCase(params);

      // Assert
      await expectLater(call, throwsA(isA<ValidationFailure>()));
      verifyNever(() => repository.recordEntry(any()));
    });

    test('throws ValidationFailure when description is blank', () async {
      // Arrange
      final params = RecordEntryParams(
        workspaceId: 'w1',
        kind: LedgerEntryKind.income,
        pesos: 100,
        description: '   ',
        occurredOn: occurredOn,
      );

      // Act
      final call = useCase(params);

      // Assert
      await expectLater(call, throwsA(isA<ValidationFailure>()));
    });
  });
}
