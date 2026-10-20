import 'package:money_app/features/loans/domain/entities/loan.dart';
import 'package:money_app/features/loans/domain/repositories/loan_repository.dart';
import 'package:money_app/shared/base_domain/use_cases/no_params.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class LoadLoansUseCase implements UseCase<List<Loan>, NoParams> {
  const LoadLoansUseCase(this._repository);

  final LoanRepository _repository;

  @override
  Future<List<Loan>> call(NoParams params) => _repository.loadLoans();
}
