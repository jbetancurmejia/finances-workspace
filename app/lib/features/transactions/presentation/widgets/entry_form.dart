import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';

final class EntryFormValues {
  const EntryFormValues({
    required this.kind,
    required this.pesos,
    required this.description,
  });

  final LedgerEntryKind kind;
  final int pesos;
  final String description;
}

final class EntryForm extends StatefulWidget {
  const EntryForm({
    required this.onPreview,
    required this.onSubmit,
    required this.previewText,
    super.key,
  });

  final ValueChanged<int> onPreview;
  final ValueChanged<EntryFormValues> onSubmit;
  final String? previewText;

  @override
  State<EntryForm> createState() => _EntryFormState();
}

final class _EntryFormState extends State<EntryForm> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  LedgerEntryKind _kind = LedgerEntryKind.expense;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int get _pesos => int.tryParse(_amountController.text.trim()) ?? 0;

  void _submit() {
    widget.onSubmit(
      EntryFormValues(
        kind: _kind,
        pesos: _pesos,
        description: _descriptionController.text,
      ),
    );
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<LedgerEntryKind>(
          segments: [
            ButtonSegment(
              value: LedgerEntryKind.expense,
              label: Text('transactions.kindExpense'.tr()),
            ),
            ButtonSegment(
              value: LedgerEntryKind.income,
              label: Text('transactions.kindIncome'.tr()),
            ),
          ],
          selected: {_kind},
          onSelectionChanged: (selection) => setState(() => _kind = selection.first),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'transactions.amountLabel'.tr()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionController,
          decoration: InputDecoration(labelText: 'transactions.descriptionLabel'.tr()),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => widget.onPreview(_pesos),
          child: Text('transactions.previewAction'.tr()),
        ),
        if (widget.previewText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.previewText!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _submit,
          child: Text('transactions.saveAction'.tr()),
        ),
      ],
    );
  }
}
