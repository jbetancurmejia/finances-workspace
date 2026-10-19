import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/shared/base_data/network/api_client.dart';

void main() {
  group('createApiClient', () {
    test('configures the base url received', () {
      // Arrange
      const baseUrl = 'http://localhost:5199';

      // Act
      final client = createApiClient(baseUrl: baseUrl);

      // Assert
      expect(client.options.baseUrl, baseUrl);
    });
  });
}
