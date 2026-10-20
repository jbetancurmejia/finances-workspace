import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/loans/domain/entities/loan.dart';
import 'package:money_app/features/loans/domain/entities/loan_draft.dart';
import 'package:money_app/features/loans/domain/repositories/loan_repository.dart';
import 'package:money_app/features/loans/domain/use_cases/create_loan_use_case.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';

class MockLoanRepository extends Mock implements LoanRepository {}

void main() {
  late MockLoanRepository repository;
  late CreateLoanUseCase useCase;
  final draft = LoanDraft(
    principalPesos: 1000000,
    annualEffectiveRatePercent: 20,
    termMonths: 12,
    startDate: DateTime(2026, 1, 31),
  );

  setUpAll(() {
    registerFallbackValue(draft);
  });

  setUp(() {
    repository = MockLoanRepository();
    useCase = CreateLoanUseCase(repository);
  });

  group('CreateLoanUseCase', () {
    test('delegates a valid loan draft to the repository', () async {
      // Arrange
      final loan = Loan(
        id: 'l1',
        principalPesos: 1000000,
        annualEffectiveRatePercent: 20,
        monthlyRatePercent: 1.5309,
        termMonths: 12,
        startDate: DateTime(2026, 1, 31),
        fixedMonthlyPaymentPesos: 91857,
        installments: const [],
      );
      when(() => repository.createLoan(draft)).thenAnswer((_) async => loan);

      // Act
      final result = await useCase(draft);

      // Assert
      expect(result, loan);
    });

    test(
      'throws ValidationFailure without calling repository for invalid term',
      () async {
        // Arrange
        final invalid = LoanDraft(
          principalPesos: 1000000,
          annualEffectiveRatePercent: 20,
          termMonths: 0,
          startDate: DateTime(2026, 1, 31),
        );

        // Act
        final call = useCase(invalid);

        // Assert
        await expectLater(call, throwsA(isA<ValidationFailure>()));
        verifyNever(() => repository.createLoan(any()));
      },
    );

    test(
      'throws ValidationFailure when rate exceeds the supported range',
      () async {
        // Arrange
        final invalid = LoanDraft(
          principalPesos: 1000000,
          annualEffectiveRatePercent: 1001,
          termMonths: 12,
          startDate: DateTime(2026, 1, 31),
        );

        // Act
        final call = useCase(invalid);

        // Assert
        await expectLater(call, throwsA(isA<ValidationFailure>()));
      },
    );
  });
}
