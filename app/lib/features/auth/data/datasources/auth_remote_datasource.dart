import 'package:dio/dio.dart';
import 'package:money_app/features/auth/data/dtos/auth_response_dto.dart';
import 'package:money_app/features/auth/domain/entities/credentials.dart';
import 'package:money_app/features/auth/domain/entities/registration.dart';

abstract interface class AuthRemoteDatasource {
  Future<AuthResponseDto> fetchLogin(Credentials credentials);

  Future<AuthResponseDto> fetchRegister(Registration registration);
}

final class AuthHttpDatasource implements AuthRemoteDatasource {
  const AuthHttpDatasource(this._client);

  final Dio _client;

  @override
  Future<AuthResponseDto> fetchLogin(Credentials credentials) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/auth/login',
      data: {'email': credentials.email, 'password': credentials.password},
    );

    return AuthResponseDto.fromJson(response.data ?? const <String, dynamic>{});
  }

  @override
  Future<AuthResponseDto> fetchRegister(Registration registration) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/auth/register',
      data: {
        'email': registration.email,
        'password': registration.password,
        'displayName': registration.displayName,
        'monthlySalary': registration.monthlySalary,
        'monthlyWorkHours': registration.monthlyWorkHours,
      },
    );

    return AuthResponseDto.fromJson(response.data ?? const <String, dynamic>{});
  }
}
