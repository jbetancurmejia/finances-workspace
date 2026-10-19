import 'package:money_app/features/life_cost/data/dtos/life_cost_dto.dart';
import 'package:money_app/features/life_cost/domain/entities/life_cost.dart';

extension LifeCostDtoMapper on LifeCostDto {
  LifeCost toEntity() => LifeCost(hours: hours, days: days);
}
