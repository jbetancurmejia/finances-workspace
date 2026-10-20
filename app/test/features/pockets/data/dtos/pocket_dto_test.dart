import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/features/pockets/data/dtos/pocket_dto.dart';
import 'package:money_app/features/pockets/data/mappers/pocket_mapper.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';

void main() {
  group('PocketDto', () {
    test('parses id, name and isOwner from json', () {
      // Arrange
      final json = <String, dynamic>{'id': 'p1', 'name': 'Hogar', 'isOwner': false};

      // Act
      final dto = PocketDto.fromJson(json);

      // Assert
      expect(dto.id, 'p1');
      expect(dto.name, 'Hogar');
      expect(dto.isOwner, isFalse);
    });

    test('maps to the pocket entity', () {
      // Arrange
      const dto = PocketDto(id: 'p1', name: 'Hogar', isOwner: true);

      // Act
      final entity = dto.toEntity();

      // Assert
      expect(entity, const Pocket(id: 'p1', name: 'Hogar', isOwner: true));
    });
  });
}
