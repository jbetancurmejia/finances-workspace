import 'package:money_app/features/life_cost/domain/entities/life_cost.dart';
import 'package:money_app/features/life_cost/domain/repositories/life_cost_repository.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';
import 'package:money_app/shared/base_domain/value_objects/money.dart';

final class LoadLifeCostUseCase implements UseCase<LifeCost, Money> {
  const LoadLifeCostUseCase(this._repository);

  final LifeCostRepository _repository;

  @override
  Future<LifeCost> call(Money params) async {
    if (params.pesos <= 0) {
      throw const ValidationFailure('amount must be positive');
    }

    return _repository.loadLifeCost(params);
  }
}
