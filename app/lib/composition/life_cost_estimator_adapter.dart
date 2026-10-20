import 'package:money_app/features/life_cost/domain/entities/life_cost.dart';
import 'package:money_app/features/transactions/domain/ports/life_cost_estimator.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';
import 'package:money_app/shared/base_domain/value_objects/money.dart';

final class LifeCostEstimatorAdapter implements LifeCostEstimator {
  const LifeCostEstimatorAdapter(this._loadLifeCost);

  final UseCase<LifeCost, Money> _loadLifeCost;

  @override
  Future<({double hours, double days})> estimate(int pesos) async {
    final lifeCost = await _loadLifeCost(Money.cop(pesos));

    return (hours: lifeCost.hours, days: lifeCost.days);
  }
}
