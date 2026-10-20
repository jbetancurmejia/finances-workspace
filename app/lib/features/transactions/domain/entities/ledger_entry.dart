import 'package:equatable/equatable.dart';

enum LedgerEntryKind { expense, income }

final class LedgerEntry extends Equatable {
  const LedgerEntry({
    required this.id,
    required this.kind,
    required this.pesos,
    required this.description,
    required this.occurredOn,
    required this.createdByUserId,
  });

  final String id;
  final LedgerEntryKind kind;
  final int pesos;
  final String description;
  final DateTime occurredOn;
  final String createdByUserId;

  @override
  List<Object?> get props => [id, kind, pesos, description, occurredOn, createdByUserId];
}
