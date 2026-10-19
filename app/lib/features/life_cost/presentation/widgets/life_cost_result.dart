import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:money_app/features/life_cost/presentation/cubit/life_cost_state.dart';

final class LifeCostResult extends StatelessWidget {
  const LifeCostResult({required this.state, super.key});

  final LifeCostState state;

  @override
  Widget build(BuildContext context) {
    final lifeCost = state.lifeCost;

    return switch (state.status) {
      LifeCostStatus.initial => const SizedBox.shrink(),
      LifeCostStatus.loading => const Center(child: CircularProgressIndicator()),
      LifeCostStatus.success when lifeCost != null => Text(
        'lifeCost.result'.tr(
          namedArgs: {
            'hours': lifeCost.hours.round().toString(),
            'days': lifeCost.days.round().toString(),
          },
        ),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      LifeCostStatus.success => const SizedBox.shrink(),
      LifeCostStatus.invalidAmount => Text('lifeCost.errors.invalidAmount'.tr()),
      LifeCostStatus.networkError => Text('lifeCost.errors.network'.tr()),
    };
  }
}
