import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/life_cost/domain/entities/life_cost.dart';
import 'package:money_app/features/life_cost/domain/repositories/life_cost_repository.dart';
import 'package:money_app/features/life_cost/domain/use_cases/load_life_cost_use_case.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/value_objects/money.dart';

class MockLifeCostRepository extends Mock implements LifeCostRepository {}

void main() {
  late MockLifeCostRepository repository;
  late LoadLifeCostUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const Money.cop(0));
  });

  setUp(() {
    repository = MockLifeCostRepository();
    useCase = LoadLifeCostUseCase(repository);
  });

  group('LoadLifeCostUseCase', () {
    test('returns the life cost from the repository when amount is positive', () async {
      // Arrange
      const expected = LifeCost(hours: 24, days: 3);
      when(() => repository.loadLifeCost(const Money.cop(300000)))
          .thenAnswer((_) async => expected);

      // Act
      final result = await useCase(const Money.cop(300000));

      // Assert
      expect(result, expected);
    });

    test('throws ValidationFailure without calling the repository when amount is zero', () async {
      // Arrange
      const amount = Money.cop(0);

      // Act
      final call = useCase(amount);

      // Assert
      await expectLater(call, throwsA(isA<ValidationFailure>()));
      verifyNever(() => repository.loadLifeCost(any()));
    });
  });
}
