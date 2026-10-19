import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/features/life_cost/data/dtos/life_cost_dto.dart';
import 'package:money_app/features/life_cost/data/mappers/life_cost_mapper.dart';
import 'package:money_app/features/life_cost/domain/entities/life_cost.dart';

void main() {
  group('LifeCostDtoMapper', () {
    test('maps dto fields to the life cost entity', () {
      // Arrange
      const dto = LifeCostDto(hours: 24, days: 3);

      // Act
      final entity = dto.toEntity();

      // Assert
      expect(entity, const LifeCost(hours: 24, days: 3));
    });
  });
}
