import 'package:money_app/features/auth/data/dtos/auth_response_dto.dart';
import 'package:money_app/features/auth/domain/entities/auth_session.dart';

extension AuthResponseDtoMapper on AuthResponseDto {
  AuthSession toEntity() => AuthSession(
    userId: userId,
    displayName: displayName,
    token: token,
  );
}
