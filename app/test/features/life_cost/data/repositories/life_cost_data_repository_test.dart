import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/life_cost/data/datasources/life_cost_remote_datasource.dart';
import 'package:money_app/features/life_cost/data/dtos/life_cost_dto.dart';
import 'package:money_app/features/life_cost/data/repositories/life_cost_data_repository.dart';
import 'package:money_app/features/life_cost/domain/entities/life_cost.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/value_objects/money.dart';

class MockLifeCostRemoteDatasource extends Mock implements LifeCostRemoteDatasource {}

void main() {
  late MockLifeCostRemoteDatasource datasource;
  late LifeCostDataRepository repository;

  setUp(() {
    datasource = MockLifeCostRemoteDatasource();
    repository = LifeCostDataRepository(datasource);
  });

  group('LifeCostDataRepository', () {
    test('returns the mapped entity when the datasource succeeds', () async {
      // Arrange
      when(() => datasource.fetchLifeCost(300000))
          .thenAnswer((_) async => const LifeCostDto(hours: 24, days: 3));

      // Act
      final result = await repository.loadLifeCost(const Money.cop(300000));

      // Assert
      expect(result, const LifeCost(hours: 24, days: 3));
    });

    test('maps DioException to NetworkFailure', () async {
      // Arrange
      when(() => datasource.fetchLifeCost(any())).thenAnswer((_) async => throw 
        DioException(
          requestOptions: RequestOptions(path: '/api/life-cost'),
          message: 'connection refused',
        ),
      );

      // Act
      final call = repository.loadLifeCost(const Money.cop(300000));

      // Assert
      await expectLater(call, throwsA(isA<NetworkFailure>()));
    });
  });
}
