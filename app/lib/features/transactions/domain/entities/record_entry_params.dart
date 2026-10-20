import 'package:equatable/equatable.dart';
import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';

final class RecordEntryParams extends Equatable {
  const RecordEntryParams({
    required this.workspaceId,
    required this.kind,
    required this.pesos,
    required this.description,
    required this.occurredOn,
  });

  final String workspaceId;
  final LedgerEntryKind kind;
  final int pesos;
  final String description;
  final DateTime occurredOn;

  @override
  List<Object?> get props => [workspaceId, kind, pesos, description, occurredOn];
}
