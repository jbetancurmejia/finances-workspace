import 'package:money_app/features/pockets/domain/entities/pocket.dart';
import 'package:money_app/features/pockets/domain/repositories/pocket_repository.dart';
import 'package:money_app/shared/base_domain/use_cases/no_params.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class LoadPocketsUseCase implements UseCase<List<Pocket>, NoParams> {
  const LoadPocketsUseCase(this._repository);

  final PocketRepository _repository;

  @override
  Future<List<Pocket>> call(NoParams params) => _repository.loadPockets();
}
