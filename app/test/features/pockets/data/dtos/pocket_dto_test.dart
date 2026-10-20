import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/features/pockets/data/dtos/pocket_dto.dart';
import 'package:money_app/features/pockets/data/mappers/pocket_mapper.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';
import 'package:money_app/features/pockets/domain/value_objects/card_status.dart';

void main() {
  group('PocketDto', () {
    test('parses id, name and isOwner from json', () {
      // Arrange
      final json = <String, dynamic>{
        'id': 'p1',
        'name': 'Hogar',
        'isOwner': false,
      };

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

  group('PocketDto status and balance', () {
    test('parses balance and status from json', () {
      // Arrange
      final json = <String, dynamic>{
        'id': 'p1',
        'name': 'Hogar',
        'isOwner': true,
        'balance': 1700000,
        'status': 'Green',
      };

      // Act
      final pocket = PocketDto.fromJson(json).toEntity();

      // Assert
      expect(pocket.balance, 1700000);
      expect(pocket.status, CardStatus.green);
    });

    test('maps Yellow to CardStatus.yellow', () {
      // Arrange
      const dto = PocketDto(
        id: 'p1',
        name: 'Hogar',
        isOwner: true,
        status: 'Yellow',
      );

      // Act
      final pocket = dto.toEntity();

      // Assert
      expect(pocket.status, CardStatus.yellow);
    });

    test('maps Red to CardStatus.red', () {
      // Arrange
      const dto = PocketDto(
        id: 'p1',
        name: 'Hogar',
        isOwner: true,
        status: 'Red',
      );

      // Act
      final pocket = dto.toEntity();

      // Assert
      expect(pocket.status, CardStatus.red);
    });

    test('falls back to red for an unknown status from the server', () {
      // Arrange
      const dto = PocketDto(
        id: 'p1',
        name: 'Hogar',
        isOwner: true,
        status: 'Purple',
      );

      // Act
      final pocket = dto.toEntity();

      // Assert
      expect(pocket.status, CardStatus.red);
    });

    test('defaults balance to zero and status to red when json omits them', () {
      // Arrange
      final json = <String, dynamic>{
        'id': 'p1',
        'name': 'Hogar',
        'isOwner': true,
      };

      // Act
      final pocket = PocketDto.fromJson(json).toEntity();

      // Assert
      expect(pocket.balance, 0);
      expect(pocket.status, CardStatus.red);
    });
  });
}
