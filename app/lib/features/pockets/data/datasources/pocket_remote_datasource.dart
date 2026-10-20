import 'package:dio/dio.dart';
import 'package:money_app/features/pockets/data/dtos/pocket_dto.dart';
import 'package:money_app/features/pockets/domain/entities/add_member_params.dart';

abstract interface class PocketRemoteDatasource {
  Future<List<PocketDto>> fetchPockets();

  Future<PocketDto> fetchCreatePocket(String name);

  Future<void> fetchAddMember(AddMemberParams params);
}

final class PocketHttpDatasource implements PocketRemoteDatasource {
  const PocketHttpDatasource(this._client);

  final Dio _client;

  @override
  Future<List<PocketDto>> fetchPockets() async {
    final response = await _client.get<List<dynamic>>('/api/workspaces');

    return (response.data ?? const <dynamic>[])
        .cast<Map<String, dynamic>>()
        .map(PocketDto.fromJson)
        .toList();
  }

  @override
  Future<PocketDto> fetchCreatePocket(String name) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/workspaces',
      data: {'name': name},
    );

    return PocketDto.fromJson(response.data ?? const <String, dynamic>{});
  }

  @override
  Future<void> fetchAddMember(AddMemberParams params) async {
    await _client.post<void>(
      '/api/workspaces/${params.pocketId}/members',
      data: {'email': params.email},
    );
  }
}
