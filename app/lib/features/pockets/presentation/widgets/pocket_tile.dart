import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';

final class PocketTile extends StatelessWidget {
  const PocketTile({
    required this.pocket,
    required this.onOpen,
    required this.onAddMember,
    super.key,
  });

  final Pocket pocket;
  final VoidCallback onOpen;
  final VoidCallback onAddMember;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onOpen,
        title: Text(pocket.name),
        subtitle: Text(
          pocket.isOwner ? 'pockets.ownerRole'.tr() : 'pockets.sharedRole'.tr(),
        ),
        trailing: pocket.isOwner
            ? IconButton(
                tooltip: 'pockets.addMemberTooltip'.tr(),
                icon: const Icon(Icons.person_add_alt_1),
                onPressed: onAddMember,
              )
            : null,
      ),
    );
  }
}
