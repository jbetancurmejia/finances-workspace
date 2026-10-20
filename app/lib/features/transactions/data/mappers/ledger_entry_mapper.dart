import 'package:money_app/features/transactions/data/dtos/ledger_entry_dto.dart';
import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';

extension LedgerEntryDtoMapper on LedgerEntryDto {
  LedgerEntry toEntity() => LedgerEntry(
    id: id,
    kind: kind == 'Income' ? LedgerEntryKind.income : LedgerEntryKind.expense,
    pesos: amount.round(),
    description: description,
    occurredOn: DateTime.parse(occurredOn),
    createdByUserId: createdByUserId,
  );
}
