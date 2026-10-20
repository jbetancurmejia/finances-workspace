import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';
import 'package:money_app/features/transactions/domain/entities/record_entry_params.dart';

abstract interface class TransactionRepository {
  Future<List<LedgerEntry>> loadEntries(String workspaceId);

  Future<LedgerEntry> recordEntry(RecordEntryParams params);
}
