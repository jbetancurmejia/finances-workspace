import 'package:dio/dio.dart';
import 'package:money_app/features/transactions/data/dtos/ledger_entry_dto.dart';
import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';
import 'package:money_app/features/transactions/domain/entities/record_entry_params.dart';

abstract interface class TransactionRemoteDatasource {
  Future<List<LedgerEntryDto>> fetchEntries(String workspaceId);

  Future<LedgerEntryDto> fetchRecordEntry(RecordEntryParams params);
}

final class TransactionHttpDatasource implements TransactionRemoteDatasource {
  const TransactionHttpDatasource(this._client);

  final Dio _client;

  @override
  Future<List<LedgerEntryDto>> fetchEntries(String workspaceId) async {
    final response = await _client.get<List<dynamic>>(
      '/api/workspaces/$workspaceId/transactions',
    );

    return (response.data ?? const <dynamic>[])
        .cast<Map<String, dynamic>>()
        .map(LedgerEntryDto.fromJson)
        .toList();
  }

  @override
  Future<LedgerEntryDto> fetchRecordEntry(RecordEntryParams params) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/workspaces/${params.workspaceId}/transactions',
      data: {
        'kind': params.kind == LedgerEntryKind.income ? 'Income' : 'Expense',
        'amount': params.pesos,
        'description': params.description,
        'occurredOn': LedgerEntryDto.formatDate(params.occurredOn),
      },
    );

    return LedgerEntryDto.fromJson(response.data ?? const <String, dynamic>{});
  }
}
