import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:money_app/features/transactions/data/dtos/ledger_entry_dto.dart';
import 'package:money_app/features/transactions/data/repositories/transaction_data_repository.dart';
import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';
import 'package:money_app/features/transactions/domain/entities/record_entry_params.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';

class MockTransactionRemoteDatasource extends Mock implements TransactionRemoteDatasource {}

DioException _httpError(int status) {
  final request = RequestOptions(path: '/api/workspaces/w1/transactions');
  return DioException(
    requestOptions: request,
    response: Response<Map<String, dynamic>>(requestOptions: request, statusCode: status),
    type: DioExceptionType.badResponse,
    message: 'status $status',
  );
}

void main() {
  late MockTransactionRemoteDatasource datasource;
  late TransactionDataRepository repository;
  final params = RecordEntryParams(
    workspaceId: 'w1',
    kind: LedgerEntryKind.expense,
    pesos: 300000,
    description: 'Mercado',
    occurredOn: DateTime(2026, 10, 18),
  );

  setUpAll(() {
    registerFallbackValue(params);
  });

  setUp(() {
    datasource = MockTransactionRemoteDatasource();
    repository = TransactionDataRepository(datasource);
  });

  group('TransactionDataRepository.loadEntries', () {
    test('maps every dto to a ledger entry', () async {
      // Arrange
      when(() => datasource.fetchEntries('w1')).thenAnswer(
        (_) async => const [
          LedgerEntryDto(
            id: 'e1',
            kind: 'Expense',
            amount: 300000,
            description: 'Mercado',
            occurredOn: '2026-10-18',
            createdByUserId: 'u1',
          ),
        ],
      );

      // Act
      final entries = await repository.loadEntries('w1');

      // Assert
      expect(entries.single.pesos, 300000);
    });
  });

  group('TransactionDataRepository.recordEntry', () {
    test('maps HTTP 404 to NotFoundFailure', () async {
      // Arrange
      when(() => datasource.fetchRecordEntry(any())).thenAnswer((_) async => throw _httpError(404));

      // Act
      final call = repository.recordEntry(params);

      // Assert
      await expectLater(call, throwsA(isA<NotFoundFailure>()));
    });

    test('maps HTTP 400 to ValidationFailure', () async {
      // Arrange
      when(() => datasource.fetchRecordEntry(any())).thenAnswer((_) async => throw _httpError(400));

      // Act
      final call = repository.recordEntry(params);

      // Assert
      await expectLater(call, throwsA(isA<ValidationFailure>()));
    });
  });
}
