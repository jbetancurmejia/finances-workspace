import 'package:money_app/features/auth/domain/entities/auth_session.dart';
import 'package:money_app/features/auth/domain/entities/credentials.dart';
import 'package:money_app/features/auth/domain/entities/registration.dart';

abstract interface class AuthRepository {
  Future<AuthSession> login(Credentials credentials);

  Future<AuthSession> register(Registration registration);
}
