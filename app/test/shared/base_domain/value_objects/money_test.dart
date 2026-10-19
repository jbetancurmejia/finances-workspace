import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/shared/base_domain/value_objects/money.dart';

void main() {
  group('Money', () {
    test('two values with the same minor units are equal', () {
      // Arrange & Act
      const first = Money.cop(30000000);
      const second = Money.cop(30000000);

      // Assert
      expect(first, second);
    });

    test('values with different minor units are not equal', () {
      // Arrange & Act
      const first = Money.cop(30000000);
      const second = Money.cop(1500000);

      // Assert
      expect(first, isNot(second));
    });
  });
}
