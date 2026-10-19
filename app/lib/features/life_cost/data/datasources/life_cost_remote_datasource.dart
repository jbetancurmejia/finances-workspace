import 'package:dio/dio.dart';
import 'package:money_app/features/life_cost/data/dtos/life_cost_dto.dart';

abstract interface class LifeCostRemoteDatasource {
  Future<LifeCostDto> fetchLifeCost(int pesos);
}

final class LifeCostHttpDatasource implements LifeCostRemoteDatasource {
  const LifeCostHttpDatasource(this._client);

  final Dio _client;

  @override
  Future<LifeCostDto> fetchLifeCost(int pesos) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/life-cost',
      data: {'amount': pesos},
    );

    return LifeCostDto.fromJson(response.data ?? const <String, dynamic>{});
  }
}
