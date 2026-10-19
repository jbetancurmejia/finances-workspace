import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/auth/domain/entities/auth_session.dart';
import 'package:money_app/features/auth/domain/entities/registration.dart';
import 'package:money_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:money_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late RegisterUseCase useCase;

  const validRegistration = Registration(
    email: 'juan@example.com',
    password: 'secret123',
    displayName: 'Juan',
    monthlySalary: 2000000,
    monthlyWorkHours: 160,
  );

  setUpAll(() {
    registerFallbackValue(validRegistration);
  });

  setUp(() {
    repository = MockAuthRepository();
    useCase = RegisterUseCase(repository);
  });

  group('RegisterUseCase', () {
    test('returns the session when the registration is valid', () async {
      // Arrange
      const session = AuthSession(userId: 'u1', displayName: 'Juan', token: 't');
      when(() => repository.register(validRegistration)).thenAnswer((_) async => session);

      // Act
      final result = await useCase(validRegistration);

      // Assert
      expect(result, session);
    });

    test('throws ValidationFailure when password has fewer than 8 characters', () async {
      // Arrange
      const registration = Registration(
        email: 'juan@example.com',
        password: 'short',
        displayName: 'Juan',
        monthlySalary: 2000000,
        monthlyWorkHours: 160,
      );

      // Act
      final call = useCase(registration);

      // Assert
      await expectLater(call, throwsA(isA<ValidationFailure>()));
      verifyNever(() => repository.register(any()));
    });

    test('throws ValidationFailure when salary is not positive', () async {
      // Arrange
      const registration = Registration(
        email: 'juan@example.com',
        password: 'secret123',
        displayName: 'Juan',
        monthlySalary: 0,
        monthlyWorkHours: 160,
      );

      // Act
      final call = useCase(registration);

      // Assert
      await expectLater(call, throwsA(isA<ValidationFailure>()));
    });
  });
}
