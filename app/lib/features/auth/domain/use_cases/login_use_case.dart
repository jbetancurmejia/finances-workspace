import 'package:money_app/features/auth/domain/entities/auth_session.dart';
import 'package:money_app/features/auth/domain/entities/credentials.dart';
import 'package:money_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class LoginUseCase implements UseCase<AuthSession, Credentials> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<AuthSession> call(Credentials params) async {
    if (params.email.trim().isEmpty || params.password.isEmpty) {
      throw const ValidationFailure('email and password are required');
    }

    return _repository.login(params);
  }
}
