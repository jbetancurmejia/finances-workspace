import 'package:intl/intl.dart';

final class LedgerEntryDto {
  const LedgerEntryDto({
    required this.id,
    required this.kind,
    required this.amount,
    required this.description,
    required this.occurredOn,
    required this.createdByUserId,
  });

  factory LedgerEntryDto.fromJson(Map<String, dynamic> json) {
    return LedgerEntryDto(
      id: json['id'] as String,
      kind: json['kind'] as String,
      amount: (json['amount'] as num).toInt(),
      description: json['description'] as String,
      occurredOn: json['occurredOn'] as String,
      createdByUserId: json['createdByUserId'] as String,
    );
  }

  static String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  final String id;
  final String kind;
  final int amount;
  final String description;
  final String occurredOn;
  final String createdByUserId;
}
