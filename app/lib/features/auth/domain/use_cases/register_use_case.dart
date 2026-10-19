import 'package:money_app/features/auth/domain/entities/auth_session.dart';
import 'package:money_app/features/auth/domain/entities/registration.dart';
import 'package:money_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class RegisterUseCase implements UseCase<AuthSession, Registration> {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  static const _minPasswordLength = 8;

  @override
  Future<AuthSession> call(Registration params) async {
    if (params.password.length < _minPasswordLength) {
      throw const ValidationFailure('password must have at least 8 characters');
    }
    if (params.monthlySalary <= 0 || params.monthlyWorkHours <= 0) {
      throw const ValidationFailure('salary and work hours must be positive');
    }

    return _repository.register(params);
  }
}
