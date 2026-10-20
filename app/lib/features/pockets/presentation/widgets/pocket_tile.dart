import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';
import 'package:money_app/features/pockets/domain/value_objects/card_status.dart';

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
    final colors = _CardColors.of(context, pocket.status);

    return Card(
      color: colors.background,
      child: ListTile(
        onTap: onOpen,
        leading: CircleAvatar(backgroundColor: colors.accent, radius: 8),
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

  static String _formatPesos(int pesos) =>
      NumberFormat.currency(locale: 'es_CO', symbol: r'$', decimalDigits: 0).format(pesos);
}

final class _CardColors {
  const _CardColors({required this.background, required this.accent});

  final Color background;
  final Color accent;

  static _CardColors of(BuildContext context, CardStatus status) {
    final scheme = Theme.of(context).colorScheme;

    return switch (status) {
      CardStatus.green => _CardColors(
        background: Colors.green.shade50,
        accent: Colors.green.shade600,
      ),
      CardStatus.yellow => _CardColors(
        background: Colors.amber.shade50,
        accent: Colors.amber.shade700,
      ),
      CardStatus.red => _CardColors(
        background: scheme.errorContainer,
        accent: scheme.error,
      ),
    };
  }
}
