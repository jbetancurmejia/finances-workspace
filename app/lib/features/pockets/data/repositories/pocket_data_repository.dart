import 'package:dio/dio.dart';
import 'package:money_app/features/pockets/data/datasources/pocket_remote_datasource.dart';
import 'package:money_app/features/pockets/data/mappers/pocket_mapper.dart';
import 'package:money_app/features/pockets/domain/entities/add_member_params.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';
import 'package:money_app/features/pockets/domain/repositories/pocket_repository.dart';
import 'package:money_app/shared/base_data/network/http_failure_mapper.dart';

final class PocketDataRepository implements PocketRepository {
  const PocketDataRepository(this._datasource);

  final PocketRemoteDatasource _datasource;

  @override
  Future<List<Pocket>> loadPockets() async {
    try {
      final dtos = await _datasource.fetchPockets();

      return dtos.map((dto) => dto.toEntity()).toList();
    } on DioException catch (error) {
      throw mapHttpFailure(error);
    }
  }

  @override
  Future<Pocket> createPocket(String name) async {
    try {
      return (await _datasource.fetchCreatePocket(name)).toEntity();
    } on DioException catch (error) {
      throw mapHttpFailure(error);
    }
  }

  @override
  Future<void> addMember(AddMemberParams params) async {
    try {
      await _datasource.fetchAddMember(params);
    } on DioException catch (error) {
      throw mapHttpFailure(error);
    }
  }
}
