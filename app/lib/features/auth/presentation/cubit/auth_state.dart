import 'package:equatable/equatable.dart';
import 'package:money_app/features/auth/domain/entities/auth_session.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  invalidCredentials,
  emailTaken,
  invalidInput,
  networkError,
}

final class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.initial, this.session});

  final AuthStatus status;
  final AuthSession? session;

  @override
  List<Object?> get props => [status, session];
}
