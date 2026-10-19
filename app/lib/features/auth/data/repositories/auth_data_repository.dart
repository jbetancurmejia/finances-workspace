import 'package:dio/dio.dart';
import 'package:money_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:money_app/features/auth/data/mappers/auth_session_mapper.dart';
import 'package:money_app/features/auth/domain/entities/auth_session.dart';
import 'package:money_app/features/auth/domain/entities/credentials.dart';
import 'package:money_app/features/auth/domain/entities/registration.dart';
import 'package:money_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:money_app/shared/base_data/network/auth_token_store.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';

final class AuthDataRepository implements AuthRepository {
  const AuthDataRepository(this._datasource, this._tokenStore);

  final AuthRemoteDatasource _datasource;
  final AuthTokenStore _tokenStore;

  @override
  Future<AuthSession> login(Credentials credentials) async {
    try {
      final session = (await _datasource.fetchLogin(credentials)).toEntity();
      _tokenStore.save(session.token);

      return session;
    } on DioException catch (error) {
      throw _mapFailure(error, unauthorizedOnStatus: true);
    }
  }

  @override
  Future<AuthSession> register(Registration registration) async {
    try {
      final session = (await _datasource.fetchRegister(registration)).toEntity();
      _tokenStore.save(session.token);

      return session;
    } on DioException catch (error) {
      throw _mapFailure(error, unauthorizedOnStatus: false);
    }
  }

  Failure _mapFailure(DioException error, {required bool unauthorizedOnStatus}) {
    final status = error.response?.statusCode;
    final message = error.message ?? 'network error';

    return switch (status) {
      401 when unauthorizedOnStatus => UnauthorizedFailure(message),
      409 => ConflictFailure(message),
      400 => ValidationFailure(message),
      _ => NetworkFailure(message),
    };
  }
}
