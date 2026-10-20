import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:money_app/features/auth/data/dtos/auth_response_dto.dart';
import 'package:money_app/features/auth/data/repositories/auth_data_repository.dart';
import 'package:money_app/features/auth/domain/entities/auth_session.dart';
import 'package:money_app/features/auth/domain/entities/credentials.dart';
import 'package:money_app/features/auth/domain/entities/registration.dart';
import 'package:money_app/shared/base_data/network/auth_token_store.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

DioException _httpError(int status) {
  final request = RequestOptions(path: '/api/auth');
  return DioException(
    requestOptions: request,
    response: Response<Map<String, dynamic>>(requestOptions: request, statusCode: status),
    type: DioExceptionType.badResponse,
    message: 'status $status',
  );
}

void main() {
  late MockAuthRemoteDatasource datasource;
  late AuthTokenStore tokenStore;
  late AuthDataRepository repository;

  const credentials = Credentials(email: 'juan@example.com', password: 'secret123');
  const registration = Registration(
    email: 'juan@example.com',
    password: 'secret123',
    displayName: 'Juan',
    monthlySalary: 2000000,
    monthlyWorkHours: 160,
  );

  setUpAll(() {
    registerFallbackValue(credentials);
    registerFallbackValue(registration);
  });

  setUp(() {
    datasource = MockAuthRemoteDatasource();
    tokenStore = AuthTokenStore();
    repository = AuthDataRepository(datasource, tokenStore);
  });

  group('AuthDataRepository.login', () {
    test('returns the session and stores the token when credentials are valid', () async {
      // Arrange
      when(() => datasource.fetchLogin(credentials)).thenAnswer(
        (_) async => const AuthResponseDto(token: 't1', userId: 'u1', displayName: 'Juan'),
      );

      // Act
      final session = await repository.login(credentials);

      // Assert
      expect(session, const AuthSession(userId: 'u1', displayName: 'Juan', token: 't1'));
      expect(tokenStore.token, 't1');
    });

    test('maps HTTP 401 to UnauthorizedFailure and keeps no token', () async {
      // Arrange
      when(() => datasource.fetchLogin(any())).thenAnswer((_) async => throw _httpError(401));

      // Act
      final call = repository.login(credentials);

      // Assert
      await expectLater(call, throwsA(isA<UnauthorizedFailure>()));
      expect(tokenStore.token, isNull);
    });
  });

  group('AuthDataRepository.register', () {
    test('maps HTTP 409 to ConflictFailure', () async {
      // Arrange
      when(() => datasource.fetchRegister(any())).thenAnswer((_) async => throw _httpError(409));

      // Act
      final call = repository.register(registration);

      // Assert
      await expectLater(call, throwsA(isA<ConflictFailure>()));
    });

    test('maps HTTP 400 to ValidationFailure', () async {
      // Arrange
      when(() => datasource.fetchRegister(any())).thenAnswer((_) async => throw _httpError(400));

      // Act
      final call = repository.register(registration);

      // Assert
      await expectLater(call, throwsA(isA<ValidationFailure>()));
    });
  });
}
