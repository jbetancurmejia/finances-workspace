import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';
import 'package:money_app/features/transactions/domain/entities/record_entry_params.dart';
import 'package:money_app/features/transactions/domain/ports/life_cost_estimator.dart';
import 'package:money_app/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:money_app/features/transactions/presentation/cubit/transactions_state.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

class MockLoadEntries extends Mock implements UseCase<List<LedgerEntry>, String> {}

class MockRecordEntry extends Mock implements UseCase<LedgerEntry, RecordEntryParams> {}

class MockEstimator extends Mock implements LifeCostEstimator {}

void main() {
  late MockLoadEntries loadEntries;
  late MockRecordEntry recordEntry;
  late MockEstimator estimator;
  final occurredOn = DateTime(2026, 10, 18);
  final entry = LedgerEntry(
    id: 'e1',
    kind: LedgerEntryKind.expense,
    pesos: 300000,
    description: 'Mercado',
    occurredOn: occurredOn,
    createdByUserId: 'u1',
  );
  final params = RecordEntryParams(
    workspaceId: 'w1',
    kind: LedgerEntryKind.expense,
    pesos: 300000,
    description: 'Mercado',
    occurredOn: occurredOn,
  );

  setUpAll(() {
    registerFallbackValue(params);
  });

  setUp(() {
    loadEntries = MockLoadEntries();
    recordEntry = MockRecordEntry();
    estimator = MockEstimator();
  });

  TransactionsCubit build() => TransactionsCubit('w1', loadEntries, recordEntry, estimator);

  group('TransactionsCubit.load', () {
    blocTest<TransactionsCubit, TransactionsState>(
      'emits loading then loaded with the entries of the workspace',
      // Arrange
      build: () {
        when(() => loadEntries('w1')).thenAnswer((_) async => [entry]);
        return build();
      },
      // Act
      act: (cubit) => cubit.load(),
      // Assert
      expect: () => [
        const TransactionsState(status: TransactionsStatus.loading),
        TransactionsState(status: TransactionsStatus.loaded, entries: [entry]),
      ],
    );
  });

  group('TransactionsCubit.previewLifeCost', () {
    blocTest<TransactionsCubit, TransactionsState>(
      'stores the estimated hours and days',
      // Arrange
      build: () {
        when(() => estimator.estimate(300000)).thenAnswer((_) async => (hours: 24.0, days: 3.0));
        return build();
      },
      // Act
      act: (cubit) => cubit.previewLifeCost(300000),
      // Assert
      expect: () => [
        const TransactionsState(previewHours: 24, previewDays: 3),
      ],
    );
  });

  group('TransactionsCubit.record', () {
    blocTest<TransactionsCubit, TransactionsState>(
      'emits recorded then reloads entries and clears the preview',
      // Arrange
      build: () {
        when(() => recordEntry(any())).thenAnswer((_) async => entry);
        when(() => loadEntries('w1')).thenAnswer((_) async => [entry]);
        return build();
      },
      // Act
      act: (cubit) => cubit.record(params),
      // Assert
      expect: () => [
        const TransactionsState(status: TransactionsStatus.recorded),
        const TransactionsState(status: TransactionsStatus.loading),
        TransactionsState(status: TransactionsStatus.loaded, entries: [entry]),
      ],
    );

    blocTest<TransactionsCubit, TransactionsState>(
      'emits invalidInput when the use case rejects the entry',
      // Arrange
      build: () {
        when(() => recordEntry(any())).thenAnswer((_) async => throw const ValidationFailure('bad'));
        return build();
      },
      // Act
      act: (cubit) => cubit.record(params),
      // Assert
      expect: () => [
        const TransactionsState(status: TransactionsStatus.invalidInput),
      ],
    );
  });
}
