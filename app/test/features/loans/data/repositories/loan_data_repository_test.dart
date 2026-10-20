import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/loans/data/datasources/loan_remote_datasource.dart';
import 'package:money_app/features/loans/data/dtos/loan_dto.dart';
import 'package:money_app/features/loans/data/dtos/loan_installment_dto.dart';
import 'package:money_app/features/loans/data/repositories/loan_data_repository.dart';
import 'package:money_app/features/loans/domain/entities/loan_draft.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';

class MockLoanRemoteDatasource extends Mock implements LoanRemoteDatasource {}

DioException _serverError() {
  final request = RequestOptions(path: '/api/loans');
  return DioException(requestOptions: request, message: 'server unavailable');
}

void main() {
  late MockLoanRemoteDatasource datasource;
  late LoanDataRepository repository;
  final draft = LoanDraft(
    principalPesos: 1000000,
    annualEffectiveRatePercent: 20,
    termMonths: 1,
    startDate: DateTime(2026, 1, 31),
  );

  setUpAll(() {
    registerFallbackValue(draft);
  });

  setUp(() {
    datasource = MockLoanRemoteDatasource();
    repository = LoanDataRepository(datasource);
  });

  group('LoanDataRepository', () {
    test('maps the created loan dto to domain', () async {
      // Arrange
      const dto = LoanDto(
        id: 'l1',
        principal: 1000000,
        annualEffectiveRatePercent: 20,
        monthlyRatePercent: 1.5309,
        termMonths: 1,
        startDate: '2026-01-31',
        fixedMonthlyPayment: 91857,
        installments: [
          LoanInstallmentDto(
            number: 1,
            dueDate: '2026-02-28',
            payment: 91857,
            principalPayment: 76548,
            interestPayment: 15309,
            remainingBalance: 0,
          ),
        ],
      );
      when(
        () => datasource.fetchCreateLoan(draft),
      ).thenAnswer((_) async => dto);

      // Act
      final loan = await repository.createLoan(draft);

      // Assert
      expect(loan.id, 'l1');
      expect(loan.installments, hasLength(1));
    });

    test('maps DioException to NetworkFailure', () async {
      // Arrange
      when(
        () => datasource.fetchLoans(),
      ).thenAnswer((_) async => throw _serverError());

      // Act
      final call = repository.loadLoans();

      // Assert
      await expectLater(call, throwsA(isA<NetworkFailure>()));
    });
  });
}
