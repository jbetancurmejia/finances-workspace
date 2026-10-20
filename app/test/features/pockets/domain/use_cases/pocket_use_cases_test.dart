import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/pockets/domain/entities/add_member_params.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';
import 'package:money_app/features/pockets/domain/repositories/pocket_repository.dart';
import 'package:money_app/features/pockets/domain/use_cases/add_pocket_member_use_case.dart';
import 'package:money_app/features/pockets/domain/use_cases/create_pocket_use_case.dart';
import 'package:money_app/features/pockets/domain/use_cases/load_pockets_use_case.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/no_params.dart';

class MockPocketRepository extends Mock implements PocketRepository {}

void main() {
  late MockPocketRepository repository;

  setUpAll(() {
    registerFallbackValue(const AddMemberParams(pocketId: '', email: ''));
  });

  setUp(() {
    repository = MockPocketRepository();
  });

  group('LoadPocketsUseCase', () {
    test('returns the pockets from the repository', () async {
      // Arrange
      const pockets = [Pocket(id: 'p1', name: 'Hogar', isOwner: true)];
      when(() => repository.loadPockets()).thenAnswer((_) async => pockets);
      final useCase = LoadPocketsUseCase(repository);

      // Act
      final result = await useCase(const NoParams());

      // Assert
      expect(result, pockets);
    });
  });

  group('CreatePocketUseCase', () {
    test('trims the name before delegating to the repository', () async {
      // Arrange
      const created = Pocket(id: 'p1', name: 'Hogar', isOwner: true);
      when(() => repository.createPocket('Hogar')).thenAnswer((_) async => created);
      final useCase = CreatePocketUseCase(repository);

      // Act
      final result = await useCase('  Hogar  ');

      // Assert
      expect(result, created);
    });

    test('throws ValidationFailure without calling the repository when name is blank', () async {
      // Arrange
      final useCase = CreatePocketUseCase(repository);

      // Act
      final call = useCase('   ');

      // Assert
      await expectLater(call, throwsA(isA<ValidationFailure>()));
      verifyNever(() => repository.createPocket(any()));
    });
  });

  group('AddPocketMemberUseCase', () {
    test('delegates with the trimmed email', () async {
      // Arrange
      when(() => repository.addMember(any())).thenAnswer((_) async {});
      final useCase = AddPocketMemberUseCase(repository);

      // Act
      await useCase(const AddMemberParams(pocketId: 'p1', email: '  pareja@example.com '));

      // Assert
      verify(() => repository.addMember(
            const AddMemberParams(pocketId: 'p1', email: 'pareja@example.com'),
          )).called(1);
    });

    test('throws ValidationFailure without calling the repository when email is blank', () async {
      // Arrange
      final useCase = AddPocketMemberUseCase(repository);

      // Act
      final call = useCase(const AddMemberParams(pocketId: 'p1', email: ' '));

      // Assert
      await expectLater(call, throwsA(isA<ValidationFailure>()));
      verifyNever(() => repository.addMember(any()));
    });
  });
}
