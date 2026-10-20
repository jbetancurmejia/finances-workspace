import 'package:dio/dio.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';

Failure mapHttpFailure(DioException error) {
  final message = error.message ?? 'network error';

  return switch (error.response?.statusCode) {
    400 => ValidationFailure(message),
    401 => UnauthorizedFailure(message),
    404 => NotFoundFailure(message),
    409 => ConflictFailure(message),
    _ => NetworkFailure(message),
  };
}
