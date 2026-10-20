import 'package:dio/dio.dart';
import 'package:money_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:money_app/features/transactions/data/mappers/ledger_entry_mapper.dart';
import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';
import 'package:money_app/features/transactions/domain/entities/record_entry_params.dart';
import 'package:money_app/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:money_app/shared/base_data/network/http_failure_mapper.dart';

final class TransactionDataRepository implements TransactionRepository {
  const TransactionDataRepository(this._datasource);

  final TransactionRemoteDatasource _datasource;

  @override
  Future<List<LedgerEntry>> loadEntries(String workspaceId) async {
    try {
      final dtos = await _datasource.fetchEntries(workspaceId);

      return dtos.map((dto) => dto.toEntity()).toList();
    } on DioException catch (error) {
      throw mapHttpFailure(error);
    }
  }

  @override
  Future<LedgerEntry> recordEntry(RecordEntryParams params) async {
    try {
      return (await _datasource.fetchRecordEntry(params)).toEntity();
    } on DioException catch (error) {
      throw mapHttpFailure(error);
    }
  }
}
