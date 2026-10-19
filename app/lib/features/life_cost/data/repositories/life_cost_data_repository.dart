import 'package:dio/dio.dart';
import 'package:money_app/features/life_cost/data/datasources/life_cost_remote_datasource.dart';
import 'package:money_app/features/life_cost/data/mappers/life_cost_mapper.dart';
import 'package:money_app/features/life_cost/domain/entities/life_cost.dart';
import 'package:money_app/features/life_cost/domain/repositories/life_cost_repository.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/value_objects/money.dart';

final class LifeCostDataRepository implements LifeCostRepository {
  const LifeCostDataRepository(this._datasource);

  final LifeCostRemoteDatasource _datasource;

  @override
  Future<LifeCost> loadLifeCost(Money amount) async {
    try {
      final dto = await _datasource.fetchLifeCost(amount.pesos);

      return dto.toEntity();
    } on DioException catch (error) {
      throw NetworkFailure(error.message ?? 'network error');
    }
  }
}
