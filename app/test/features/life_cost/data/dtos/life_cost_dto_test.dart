import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/features/life_cost/data/dtos/life_cost_dto.dart';

void main() {
  group('LifeCostDto', () {
    test('parses integer json values as doubles', () {
      // Arrange
      final json = <String, dynamic>{'hours': 24, 'days': 3};

      // Act
      final dto = LifeCostDto.fromJson(json);

      // Assert
      expect(dto.hours, 24.0);
      expect(dto.days, 3.0);
    });
  });
}
