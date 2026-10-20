import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/auth/domain/entities/auth_session.dart';
import 'package:money_app/features/auth/domain/entities/credentials.dart';
import 'package:money_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:money_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const Credentials(email: '', password: ''));
  });

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  group('LoginUseCase', () {
    test('returns the session from the repository when credentials are present', () async {
      // Arrange
      const credentials = Credentials(email: 'juan@example.com', password: 'secret123');
      const session = AuthSession(userId: 'u1', displayName: 'Juan', token: 't');
      when(() => repository.login(credentials)).thenAnswer((_) async => session);

      // Act
      final result = await useCase(credentials);

      // Assert
      expect(result, session);
    });

    test('throws ValidationFailure without calling the repository when password is empty', () async {
      // Arrange
      const credentials = Credentials(email: 'juan@example.com', password: '');

      // Act
      final call = useCase(credentials);

      // Assert
      await expectLater(call, throwsA(isA<ValidationFailure>()));
      verifyNever(() => repository.login(any()));
    });
  });
}
