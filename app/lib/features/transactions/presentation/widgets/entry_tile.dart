import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';
import 'package:money_app/shared/design/app_colors.dart';

final class EntryTile extends StatelessWidget {
  const EntryTile({required this.entry, super.key});

  final LedgerEntry entry;

  @override
  Widget build(BuildContext context) {
    final isIncome = entry.kind == LedgerEntryKind.income;
    final amount = NumberFormat.currency(
      locale: 'es_CO',
      symbol: r'$',
      decimalDigits: 0,
    ).format(entry.pesos);

    return Card(
      child: ListTile(
        leading: Icon(
          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: isIncome
              ? AppColors.positive
              : Theme.of(context).colorScheme.error,
        ),
        title: Text(entry.description),
        subtitle: Text(DateFormat('yyyy-MM-dd').format(entry.occurredOn)),
        trailing: Text(
          isIncome ? '+ $amount' : '- $amount',
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}
