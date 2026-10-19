import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/features/auth/data/dtos/auth_response_dto.dart';

void main() {
  group('AuthResponseDto', () {
    test('parses token, userId and displayName from json', () {
      // Arrange
      final json = <String, dynamic>{
        'token': 'abc',
        'userId': 'u1',
        'displayName': 'Juan',
      };

      // Act
      final dto = AuthResponseDto.fromJson(json);

      // Assert
      expect(dto.token, 'abc');
      expect(dto.userId, 'u1');
      expect(dto.displayName, 'Juan');
    });
  });
}
