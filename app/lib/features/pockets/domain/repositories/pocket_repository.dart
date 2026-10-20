import 'package:money_app/features/pockets/domain/entities/add_member_params.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';

abstract interface class PocketRepository {
  Future<List<Pocket>> loadPockets();

  Future<Pocket> createPocket(String name);

  Future<void> addMember(AddMemberParams params);
}
