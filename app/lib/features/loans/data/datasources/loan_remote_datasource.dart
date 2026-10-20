import 'package:dio/dio.dart';
import 'package:money_app/features/loans/data/dtos/loan_dto.dart';
import 'package:money_app/features/loans/domain/entities/loan_draft.dart';

abstract interface class LoanRemoteDatasource {
  Future<List<LoanDto>> fetchLoans();

  Future<LoanDto> fetchCreateLoan(LoanDraft draft);
}

final class LoanHttpDatasource implements LoanRemoteDatasource {
  const LoanHttpDatasource(this._client);

  final Dio _client;

  @override
  Future<List<LoanDto>> fetchLoans() async {
    final response = await _client.get<List<dynamic>>('/api/loans');

    return (response.data ?? const <dynamic>[])
        .cast<Map<String, dynamic>>()
        .map(LoanDto.fromJson)
        .toList();
  }

  @override
  Future<LoanDto> fetchCreateLoan(LoanDraft draft) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/loans',
      data: {
        'principal': draft.principalPesos,
        'annualEffectiveRatePercent': draft.annualEffectiveRatePercent,
        'termMonths': draft.termMonths,
        'startDate': _formatDate(draft.startDate),
      },
    );

    return LoanDto.fromJson(response.data ?? const <String, dynamic>{});
  }

  static String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
