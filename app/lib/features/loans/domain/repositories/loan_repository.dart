import 'package:money_app/features/loans/domain/entities/loan.dart';
import 'package:money_app/features/loans/domain/entities/loan_draft.dart';

abstract interface class LoanRepository {
  Future<List<Loan>> loadLoans();

  Future<Loan> createLoan(LoanDraft draft);
}
