import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';
import 'package:money_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class LoadEntriesUseCase implements UseCase<List<LedgerEntry>, String> {
  const LoadEntriesUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<List<LedgerEntry>> call(String params) => _repository.loadEntries(params);
}
