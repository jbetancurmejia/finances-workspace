import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';
import 'package:money_app/features/transactions/domain/entities/record_entry_params.dart';
import 'package:money_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class RecordEntryUseCase implements UseCase<LedgerEntry, RecordEntryParams> {
  const RecordEntryUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<LedgerEntry> call(RecordEntryParams params) async {
    if (params.pesos <= 0) {
      throw const ValidationFailure('amount must be positive');
    }
    if (params.description.trim().isEmpty) {
      throw const ValidationFailure('description is required');
    }

    return _repository.recordEntry(
      RecordEntryParams(
        workspaceId: params.workspaceId,
        kind: params.kind,
        pesos: params.pesos,
        description: params.description.trim(),
        occurredOn: params.occurredOn,
      ),
    );
  }
}
