import 'package:dio/dio.dart';
import 'package:money_app/features/loans/data/datasources/loan_remote_datasource.dart';
import 'package:money_app/features/loans/data/mappers/loan_mapper.dart';
import 'package:money_app/features/loans/domain/entities/loan.dart';
import 'package:money_app/features/loans/domain/entities/loan_draft.dart';
import 'package:money_app/features/loans/domain/repositories/loan_repository.dart';
import 'package:money_app/shared/base_data/network/http_failure_mapper.dart';

final class LoanDataRepository implements LoanRepository {
  const LoanDataRepository(this._datasource);

  final LoanRemoteDatasource _datasource;

  @override
  Future<List<Loan>> loadLoans() async {
    try {
      return (await _datasource.fetchLoans())
          .map((dto) => dto.toEntity())
          .toList();
    } on DioException catch (error) {
      throw mapHttpFailure(error);
    }
  }

  @override
  Future<Loan> createLoan(LoanDraft draft) async {
    try {
      return (await _datasource.fetchCreateLoan(draft)).toEntity();
    } on DioException catch (error) {
      throw mapHttpFailure(error);
    }
  }
}
