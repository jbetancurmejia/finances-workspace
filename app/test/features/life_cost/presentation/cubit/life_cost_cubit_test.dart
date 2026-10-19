import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/life_cost/domain/entities/life_cost.dart';
import 'package:money_app/features/life_cost/presentation/cubit/life_cost_cubit.dart';
import 'package:money_app/features/life_cost/presentation/cubit/life_cost_state.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';
import 'package:money_app/shared/base_domain/value_objects/money.dart';

class MockLoadLifeCost extends Mock implements UseCase<LifeCost, Money> {}

void main() {
  late MockLoadLifeCost loadLifeCost;

  setUpAll(() {
    registerFallbackValue(const Money.cop(0));
  });

  setUp(() {
    loadLifeCost = MockLoadLifeCost();
  });

  group('LifeCostCubit', () {
    blocTest<LifeCostCubit, LifeCostState>(
      'emits loading then success with the calculated life cost',
      // Arrange
      build: () {
        when(() => loadLifeCost(const Money.cop(300000)))
            .thenAnswer((_) async => const LifeCost(hours: 24, days: 3));
        return LifeCostCubit(loadLifeCost);
      },
      // Act
      act: (cubit) => cubit.calculate(300000),
      // Assert
      expect: () => [
        const LifeCostState(status: LifeCostStatus.loading),
        const LifeCostState(
          status: LifeCostStatus.success,
          lifeCost: LifeCost(hours: 24, days: 3),
        ),
      ],
    );

    blocTest<LifeCostCubit, LifeCostState>(
      'emits invalidAmount when the use case rejects the amount',
      // Arrange
      build: () {
        when(() => loadLifeCost(any())).thenAnswer((_) async => throw const ValidationFailure('invalid'));
        return LifeCostCubit(loadLifeCost);
      },
      // Act
      act: (cubit) => cubit.calculate(0),
      // Assert
      expect: () => [
        const LifeCostState(status: LifeCostStatus.loading),
        const LifeCostState(status: LifeCostStatus.invalidAmount),
      ],
    );

    blocTest<LifeCostCubit, LifeCostState>(
      'emits networkError when the use case reports a network failure',
      // Arrange
      build: () {
        when(() => loadLifeCost(any())).thenAnswer((_) async => throw const NetworkFailure('down'));
        return LifeCostCubit(loadLifeCost);
      },
      // Act
      act: (cubit) => cubit.calculate(300000),
      // Assert
      expect: () => [
        const LifeCostState(status: LifeCostStatus.loading),
        const LifeCostState(status: LifeCostStatus.networkError),
      ],
    );
  });
}
