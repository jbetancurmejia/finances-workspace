import 'package:money_app/features/pockets/domain/entities/pocket.dart';
import 'package:money_app/features/pockets/domain/repositories/pocket_repository.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class CreatePocketUseCase implements UseCase<Pocket, String> {
  const CreatePocketUseCase(this._repository);

  final PocketRepository _repository;

  @override
  Future<Pocket> call(String params) async {
    final name = params.trim();

    if (name.isEmpty) {
      throw const ValidationFailure('pocket name is required');
    }

    return _repository.createPocket(name);
  }
}
