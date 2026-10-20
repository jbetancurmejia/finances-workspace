import 'package:equatable/equatable.dart';
import 'package:money_app/features/loans/domain/entities/loan.dart';

enum LoansStatus {
  initial,
  loading,
  loaded,
  created,
  invalidInput,
  networkError,
}

final class LoansState extends Equatable {
  const LoansState({this.status = LoansStatus.initial, this.loans = const []});

  final LoansStatus status;
  final List<Loan> loans;

  LoansState copyWith({LoansStatus? status, List<Loan>? loans}) =>
      LoansState(status: status ?? this.status, loans: loans ?? this.loans);

  @override
  List<Object?> get props => [status, loans];
}
