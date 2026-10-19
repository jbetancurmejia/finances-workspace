import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/life_cost/domain/entities/life_cost.dart';
import 'package:money_app/features/life_cost/presentation/cubit/life_cost_state.dart';
import 'package:money_app/shared/base_domain/failures/failure.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';
import 'package:money_app/shared/base_domain/value_objects/money.dart';

final class LifeCostCubit extends Cubit<LifeCostState> {
  LifeCostCubit(this._loadLifeCost) : super(const LifeCostState());

  final UseCase<LifeCost, Money> _loadLifeCost;

  Future<void> calculate(int pesos) async {
    emit(const LifeCostState(status: LifeCostStatus.loading));

    try {
      final lifeCost = await _loadLifeCost(Money.cop(pesos));
      emit(LifeCostState(status: LifeCostStatus.success, lifeCost: lifeCost));
    } on ValidationFailure {
      emit(const LifeCostState(status: LifeCostStatus.invalidAmount));
    } on NetworkFailure {
      emit(const LifeCostState(status: LifeCostStatus.networkError));
    }
  }
}
