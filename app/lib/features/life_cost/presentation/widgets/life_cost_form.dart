import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

final class LifeCostForm extends StatefulWidget {
  const LifeCostForm({required this.onSubmit, super.key});

  final ValueChanged<int> onSubmit;

  @override
  State<LifeCostForm> createState() => _LifeCostFormState();
}

final class _LifeCostFormState extends State<LifeCostForm> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final pesos = int.tryParse(_amountController.text.trim()) ?? 0;
    widget.onSubmit(pesos);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'lifeCost.amountLabel'.tr()),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _submit,
          child: Text('lifeCost.submit'.tr()),
        ),
      ],
    );
  }
}
