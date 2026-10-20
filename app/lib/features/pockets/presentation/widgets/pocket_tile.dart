import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';
import 'package:money_app/features/pockets/presentation/theme/card_status_palette.dart';

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
    final palette = CardStatusPalette.forStatus(
      pocket.status,
      Theme.of(context).colorScheme,
    );

    return Card(
      color: palette.background,
      child: ListTile(
        onTap: onOpen,
        leading: CircleAvatar(backgroundColor: palette.accent, radius: 8),
        title: Text(pocket.name),
        subtitle: Text(
          '${pocket.isOwner ? 'pockets.ownerRole'.tr() : 'pockets.sharedRole'.tr()} · '
          '${'pockets.balanceLabel'.tr(namedArgs: {'amount': _formatPesos(pocket.balance)})}',
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

  static String _formatPesos(int pesos) => NumberFormat.currency(
    locale: 'es_CO',
    symbol: r'$',
    decimalDigits: 0,
  ).format(pesos);
}
