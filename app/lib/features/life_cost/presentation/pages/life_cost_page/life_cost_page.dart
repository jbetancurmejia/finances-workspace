import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/life_cost/domain/entities/life_cost.dart';
import 'package:money_app/features/life_cost/presentation/cubit/life_cost_cubit.dart';
import 'package:money_app/features/life_cost/presentation/cubit/life_cost_state.dart';
import 'package:money_app/features/life_cost/presentation/widgets/life_cost_form.dart';
import 'package:money_app/features/life_cost/presentation/widgets/life_cost_result.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';
import 'package:money_app/shared/base_domain/value_objects/money.dart';

final class LifeCostPage extends StatelessWidget {
  const LifeCostPage({required this.loadLifeCost, super.key});

  final UseCase<LifeCost, Money> loadLifeCost;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LifeCostCubit(loadLifeCost),
      child: const _LifeCostView(),
    );
  }
}

final class _LifeCostView extends StatelessWidget {
  const _LifeCostView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('lifeCost.title'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LifeCostForm(
              onSubmit: (pesos) => context.read<LifeCostCubit>().calculate(pesos),
            ),
            const SizedBox(height: 32),
            BlocBuilder<LifeCostCubit, LifeCostState>(
              builder: (context, state) => LifeCostResult(state: state),
            ),
          ],
        ),
      ),
    );
  }
}
