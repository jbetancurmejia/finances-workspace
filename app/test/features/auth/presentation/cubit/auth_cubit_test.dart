import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/auth/domain/entities/auth_session.dart';
import 'package:money_app/features/auth/domain/entities/credentials.dart';
import 'package:money_app/features/auth/domain/entities/registration.dart';
import 'package:money_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:money_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

class MockLogin extends Mock implements UseCase<AuthSession, Credentials> {}

class MockRegister extends Mock implements UseCase<AuthSession, Registration> {}

void main() {
  late MockLogin login;
  late MockRegister register;

  const credentials = Credentials(email: 'juan@example.com', password: 'secret123');
  const session = AuthSession(userId: 'u1', displayName: 'Juan', token: 't1');
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
    login = MockLogin();
    register = MockRegister();
  });

  group('AuthCubit.login', () {
    blocTest<AuthCubit, AuthState>(
      'emits loading then authenticated with the session',
      // Arrange
      build: () {
        when(() => login(credentials)).thenAnswer((_) async => session);
        return AuthCubit(login, register);
      },
      // Act
      act: (cubit) => cubit.login(credentials),
      // Assert
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.authenticated, session: session),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits invalidCredentials when the use case reports unauthorized',
      // Arrange
      build: () {
        when(() => login(any())).thenAnswer((_) async => throw const UnauthorizedFailure('401'));
        return AuthCubit(login, register);
      },
      // Act
      act: (cubit) => cubit.login(credentials),
      // Assert
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.invalidCredentials),
      ],
    );
  });

  group('AuthCubit.register', () {
    blocTest<AuthCubit, AuthState>(
      'emits emailTaken when the use case reports a conflict',
      // Arrange
      build: () {
        when(() => register(any())).thenAnswer((_) async => throw const ConflictFailure('409'));
        return AuthCubit(login, register);
      },
      // Act
      act: (cubit) => cubit.register(registration),
      // Assert
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.emailTaken),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits networkError when the use case reports a network failure',
      // Arrange
      build: () {
        when(() => register(any())).thenAnswer((_) async => throw const NetworkFailure('down'));
        return AuthCubit(login, register);
      },
      // Act
      act: (cubit) => cubit.register(registration),
      // Assert
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        const AuthState(status: AuthStatus.networkError),
      ],
    );
  });
}
