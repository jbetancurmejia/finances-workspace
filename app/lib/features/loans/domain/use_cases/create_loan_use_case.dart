import 'package:money_app/features/loans/domain/entities/loan.dart';
import 'package:money_app/features/loans/domain/entities/loan_draft.dart';
import 'package:money_app/features/loans/domain/repositories/loan_repository.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class CreateLoanUseCase implements UseCase<Loan, LoanDraft> {
  const CreateLoanUseCase(this._repository);

  final LoanRepository _repository;

  @override
  Future<Loan> call(LoanDraft params) async {
    if (params.principalPesos <= 0 ||
        params.annualEffectiveRatePercent < 0 ||
        params.annualEffectiveRatePercent > 1000 ||
        params.termMonths < 1 ||
        params.termMonths > 600) {
      throw const ValidationFailure('loan values are invalid');
    }

    return _repository.createLoan(params);
  }
}
