import 'package:equatable/equatable.dart';
import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';

enum TransactionsStatus {
  initial,
  loading,
  loaded,
  recorded,
  invalidInput,
  networkError,
}

final class TransactionsState extends Equatable {
  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.entries = const [],
    this.previewHours,
    this.previewDays,
  });

  final TransactionsStatus status;
  final List<LedgerEntry> entries;
  final double? previewHours;
  final double? previewDays;

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<LedgerEntry>? entries,
    ({double hours, double days})? preview,
    bool clearPreview = false,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      previewHours: clearPreview ? null : (preview?.hours ?? previewHours),
      previewDays: clearPreview ? null : (preview?.days ?? previewDays),
    );
  }

  @override
  List<Object?> get props => [status, entries, previewHours, previewDays];
}
