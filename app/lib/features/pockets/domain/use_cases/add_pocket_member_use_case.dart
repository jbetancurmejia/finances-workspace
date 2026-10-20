import 'package:money_app/features/pockets/domain/entities/add_member_params.dart';
import 'package:money_app/features/pockets/domain/repositories/pocket_repository.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class AddPocketMemberUseCase implements UseCase<void, AddMemberParams> {
  const AddPocketMemberUseCase(this._repository);

  final PocketRepository _repository;

  @override
  Future<void> call(AddMemberParams params) async {
    if (params.email.trim().isEmpty) {
      throw const ValidationFailure('partner email is required');
    }

    return _repository.addMember(
      AddMemberParams(pocketId: params.pocketId, email: params.email.trim()),
    );
  }
}
