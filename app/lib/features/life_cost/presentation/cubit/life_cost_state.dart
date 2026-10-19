import 'package:equatable/equatable.dart';
import 'package:money_app/features/life_cost/domain/entities/life_cost.dart';

enum LifeCostStatus { initial, loading, success, invalidAmount, networkError }

final class LifeCostState extends Equatable {
  const LifeCostState({this.status = LifeCostStatus.initial, this.lifeCost});

  final LifeCostStatus status;
  final LifeCost? lifeCost;

  @override
  List<Object?> get props => [status, lifeCost];
}
