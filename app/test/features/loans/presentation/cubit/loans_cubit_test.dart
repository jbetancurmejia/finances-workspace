import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/loans/domain/entities/loan.dart';
import 'package:money_app/features/loans/domain/entities/loan_draft.dart';
import 'package:money_app/features/loans/presentation/cubit/loans_cubit.dart';
import 'package:money_app/features/loans/presentation/cubit/loans_state.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/no_params.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

class MockLoadLoans extends Mock implements UseCase<List<Loan>, NoParams> {}

class MockCreateLoan extends Mock implements UseCase<Loan, LoanDraft> {}

void main() {
  late MockLoadLoans loadLoans;
  late MockCreateLoan createLoan;
  final draft = LoanDraft(
    principalPesos: 1000000,
    annualEffectiveRatePercent: 20,
    termMonths: 12,
    startDate: DateTime(2026, 1, 31),
  );
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

  setUpAll(() {
    registerFallbackValue(draft);
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    loadLoans = MockLoadLoans();
    createLoan = MockCreateLoan();
  });

  group('LoansCubit', () {
    blocTest<LoansCubit, LoansState>(
      'emits loading then loaded when loans load successfully',
      // Arrange
      build: () {
        when(() => loadLoans(any())).thenAnswer((_) async => [loan]);
        return LoansCubit(loadLoans, createLoan);
      },
      // Act
      act: (cubit) => cubit.load(),
      // Assert
      expect: () => [
        const LoansState(status: LoansStatus.loading),
        LoansState(status: LoansStatus.loaded, loans: [loan]),
      ],
    );

    blocTest<LoansCubit, LoansState>(
      'emits invalidInput when create use case rejects draft',
      // Arrange
      build: () {
        when(
          () => createLoan(any()),
        ).thenAnswer((_) async => throw const ValidationFailure('invalid'));
        return LoansCubit(loadLoans, createLoan);
      },
      // Act
      act: (cubit) => cubit.create(draft),
      // Assert
      expect: () => [
        const LoansState(status: LoansStatus.loading),
        const LoansState(status: LoansStatus.invalidInput),
      ],
    );

    blocTest<LoansCubit, LoansState>(
      'emits created then reloads loans',
      // Arrange
      build: () {
        when(() => createLoan(any())).thenAnswer((_) async => loan);
        when(() => loadLoans(any())).thenAnswer((_) async => [loan]);
        return LoansCubit(loadLoans, createLoan);
      },
      // Act
      act: (cubit) => cubit.create(draft),
      // Assert
      expect: () => [
        const LoansState(status: LoansStatus.loading),
        const LoansState(status: LoansStatus.created),
        const LoansState(status: LoansStatus.loading),
        LoansState(status: LoansStatus.loaded, loans: [loan]),
      ],
    );
  });
}
