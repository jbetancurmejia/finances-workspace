import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';
import 'package:money_app/features/transactions/domain/entities/record_entry_params.dart';
import 'package:money_app/features/transactions/domain/ports/life_cost_estimator.dart';
import 'package:money_app/features/transactions/presentation/cubit/transactions_state.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit(this._workspaceId, this._loadEntries, this._recordEntry, this._estimator)
    : super(const TransactionsState());

  final String _workspaceId;
  final UseCase<List<LedgerEntry>, String> _loadEntries;
  final UseCase<LedgerEntry, RecordEntryParams> _recordEntry;
  final LifeCostEstimator _estimator;

  Future<void> load() async {
    emit(state.copyWith(status: TransactionsStatus.loading));

    try {
      final entries = await _loadEntries(_workspaceId);
      emit(state.copyWith(status: TransactionsStatus.loaded, entries: entries));
    } on Failure {
      emit(state.copyWith(status: TransactionsStatus.networkError));
    }
  }

  Future<void> previewLifeCost(int pesos) async {
    try {
      final preview = await _estimator.estimate(pesos);
      emit(state.copyWith(preview: preview));
    } on Failure {
      emit(state.copyWith(clearPreview: true, status: TransactionsStatus.networkError));
    }
  }

  Future<void> record(RecordEntryParams params) async {
    try {
      await _recordEntry(params);
      emit(state.copyWith(status: TransactionsStatus.recorded, clearPreview: true));
      await load();
    } on Failure catch (failure) {
      emit(state.copyWith(status: _statusFor(failure)));
    }
  }

  TransactionsStatus _statusFor(Failure failure) {
    return switch (failure) {
      ValidationFailure() => TransactionsStatus.invalidInput,
      _ => TransactionsStatus.networkError,
    };
  }
}
