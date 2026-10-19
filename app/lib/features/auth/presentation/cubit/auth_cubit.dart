import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/auth/domain/entities/auth_session.dart';
import 'package:money_app/features/auth/domain/entities/credentials.dart';
import 'package:money_app/features/auth/domain/entities/registration.dart';
import 'package:money_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._login, this._register) : super(const AuthState());

  final UseCase<AuthSession, Credentials> _login;
  final UseCase<AuthSession, Registration> _register;

  Future<void> login(Credentials credentials) async {
    emit(const AuthState(status: AuthStatus.loading));

    try {
      final session = await _login(credentials);
      emit(AuthState(status: AuthStatus.authenticated, session: session));
    } on Failure catch (failure) {
      emit(AuthState(status: _statusFor(failure)));
    }
  }

  Future<void> register(Registration registration) async {
    emit(const AuthState(status: AuthStatus.loading));

    try {
      final session = await _register(registration);
      emit(AuthState(status: AuthStatus.authenticated, session: session));
    } on Failure catch (failure) {
      emit(AuthState(status: _statusFor(failure)));
    }
  }

  AuthStatus _statusFor(Failure failure) {
    return switch (failure) {
      UnauthorizedFailure() => AuthStatus.invalidCredentials,
      ConflictFailure() => AuthStatus.emailTaken,
      ValidationFailure() => AuthStatus.invalidInput,
      _ => AuthStatus.networkError,
    };
  }
}
