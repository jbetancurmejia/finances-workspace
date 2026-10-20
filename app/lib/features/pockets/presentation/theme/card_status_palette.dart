import 'package:flutter/material.dart';
import 'package:money_app/features/pockets/domain/value_objects/card_status.dart';
import 'package:money_app/shared/design/app_colors.dart';

final class CardStatusPalette {
  const CardStatusPalette({required this.background, required this.accent});

  static const CardStatusPalette green = CardStatusPalette(
    background: Color(0xFFE8F5E9),
    accent: AppColors.positive,
  );

  static const CardStatusPalette yellow = CardStatusPalette(
    background: Color(0xFFFFF8E1),
    accent: Color(0xFFFFA000),
  );

  final Color background;
  final Color accent;

  static CardStatusPalette forStatus(CardStatus status, ColorScheme scheme) {
    return switch (status) {
      CardStatus.green => green,
      CardStatus.yellow => yellow,
      CardStatus.red => CardStatusPalette(
        background: scheme.errorContainer,
        accent: scheme.error,
      ),
    };
  }
}
