import 'package:money_app/features/life_cost/domain/entities/life_cost.dart';
import 'package:money_app/shared/base_domain/value_objects/money.dart';

abstract interface class LifeCostRepository {
  Future<LifeCost> loadLifeCost(Money amount);
}
