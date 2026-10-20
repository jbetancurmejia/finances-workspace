import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:money_app/features/loans/domain/entities/loan_draft.dart';

final class LoanForm extends StatefulWidget {
  const LoanForm({required this.isLoading, required this.onSubmit, super.key});

  final bool isLoading;
  final ValueChanged<LoanDraft> onSubmit;

  @override
  State<LoanForm> createState() => _LoanFormState();
}

final class _LoanFormState extends State<LoanForm> {
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  final _termController = TextEditingController();
  DateTime _startDate = DateTime.now();

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _termController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null && mounted) {
      setState(() => _startDate = selected);
    }
  }

  void _submit() {
    widget.onSubmit(
      LoanDraft(
        principalPesos: int.tryParse(_principalController.text.trim()) ?? 0,
        annualEffectiveRatePercent:
            double.tryParse(_rateController.text.trim().replaceAll(',', '.')) ??
            -1,
        termMonths: int.tryParse(_termController.text.trim()) ?? 0,
        startDate: _startDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('yyyy-MM-dd').format(_startDate);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'loans.formTitle'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _principalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'loans.principal'.tr()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rateController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: 'loans.eaRate'.tr()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _termController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'loans.termMonths'.tr()),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: widget.isLoading ? null : _selectStartDate,
              icon: const Icon(Icons.calendar_month),
              label: Text('loans.startDate'.tr(namedArgs: {'date': date})),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: widget.isLoading ? null : _submit,
              child: Text('loans.createAction'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
