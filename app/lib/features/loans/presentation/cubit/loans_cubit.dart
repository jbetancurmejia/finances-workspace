import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/loans/domain/entities/loan.dart';
import 'package:money_app/features/loans/domain/entities/loan_draft.dart';
import 'package:money_app/features/loans/presentation/cubit/loans_state.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/no_params.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class LoansCubit extends Cubit<LoansState> {
  LoansCubit(this._loadLoans, this._createLoan) : super(const LoansState());

  final UseCase<List<Loan>, NoParams> _loadLoans;
  final UseCase<Loan, LoanDraft> _createLoan;

  Future<void> load() async {
    emit(state.copyWith(status: LoansStatus.loading));

    try {
      final loans = await _loadLoans(const NoParams());
      emit(LoansState(status: LoansStatus.loaded, loans: loans));
    } on Failure {
      emit(state.copyWith(status: LoansStatus.networkError));
    }
  }

  Future<void> create(LoanDraft draft) async {
    emit(state.copyWith(status: LoansStatus.loading));

    try {
      await _createLoan(draft);
      emit(state.copyWith(status: LoansStatus.created));
      await load();
    } on ValidationFailure {
      emit(state.copyWith(status: LoansStatus.invalidInput));
    } on Failure {
      emit(state.copyWith(status: LoansStatus.networkError));
    }
  }
}
