import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/features/pockets/domain/value_objects/card_status.dart';
import 'package:money_app/features/pockets/presentation/theme/card_status_palette.dart';
import 'package:money_app/shared/design/app_colors.dart';

void main() {
  group('CardStatusPalette.forStatus', () {
    test('uses the green palette for a green card', () {
      // Arrange
      final scheme = ColorScheme.fromSeed(seedColor: Colors.blue);

      // Act
      final palette = CardStatusPalette.forStatus(CardStatus.green, scheme);

      // Assert
      expect(palette.background, CardStatusPalette.green.background);
      expect(palette.accent, AppColors.positive);
    });

    test('uses the yellow palette for a yellow card', () {
      // Arrange
      final scheme = ColorScheme.fromSeed(seedColor: Colors.blue);

      // Act
      final palette = CardStatusPalette.forStatus(CardStatus.yellow, scheme);

      // Assert
      expect(palette.background, CardStatusPalette.yellow.background);
      expect(palette.accent, CardStatusPalette.yellow.accent);
    });

    test('takes red colors from the theme scheme', () {
      // Arrange
      final scheme = ColorScheme.fromSeed(seedColor: Colors.blue);

      // Act
      final palette = CardStatusPalette.forStatus(CardStatus.red, scheme);

      // Assert
      expect(palette.background, scheme.errorContainer);
      expect(palette.accent, scheme.error);
    });

    test('gives each status a distinct accent color', () {
      // Arrange
      final scheme = ColorScheme.fromSeed(seedColor: Colors.blue);

      // Act
      final accents = {
        for (final status in CardStatus.values)
          status: CardStatusPalette.forStatus(status, scheme).accent,
      };

      // Assert
      expect(accents.values.toSet(), hasLength(CardStatus.values.length));
    });
  });
}
