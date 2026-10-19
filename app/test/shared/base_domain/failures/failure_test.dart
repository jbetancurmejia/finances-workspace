import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';

void main() {
  group('Failure', () {
    test('failures of the same type and message are equal', () {
      // Arrange & Act
      const first = NetworkFailure('timeout');
      const second = NetworkFailure('timeout');

      // Assert
      expect(first, second);
    });

    test('failures of different types with the same message are not equal', () {
      // Arrange & Act
      const network = NetworkFailure('error');
      const cache = CacheFailure('error');

      // Assert
      expect(network, isNot(cache));
    });
  });
}
