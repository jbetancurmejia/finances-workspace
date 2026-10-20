import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

final class AddMemberDialog extends StatefulWidget {
  const AddMemberDialog({super.key});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

final class _AddMemberDialogState extends State<AddMemberDialog> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('pockets.addMemberTitle'.tr()),
      content: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        autofocus: true,
        decoration: InputDecoration(labelText: 'pockets.partnerEmail'.tr()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('pockets.cancel'.tr()),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_emailController.text.trim()),
          child: Text('pockets.addMemberAction'.tr()),
        ),
      ],
    );
  }
}
