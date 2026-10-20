import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

final class PocketCreateForm extends StatefulWidget {
  const PocketCreateForm({required this.onSubmit, super.key});

  final ValueChanged<String> onSubmit;

  @override
  State<PocketCreateForm> createState() => _PocketCreateFormState();
}

final class _PocketCreateFormState extends State<PocketCreateForm> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSubmit(_nameController.text);
    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'pockets.newPocketLabel'.tr()),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: _submit,
          child: Text('pockets.createAction'.tr()),
        ),
      ],
    );
  }
}
