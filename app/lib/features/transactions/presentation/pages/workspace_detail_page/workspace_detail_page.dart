import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/transactions/domain/entities/ledger_entry.dart';
import 'package:money_app/features/transactions/domain/entities/record_entry_params.dart';
import 'package:money_app/features/transactions/domain/ports/life_cost_estimator.dart';
import 'package:money_app/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:money_app/features/transactions/presentation/cubit/transactions_state.dart';
import 'package:money_app/features/transactions/presentation/widgets/entry_form.dart';
import 'package:money_app/features/transactions/presentation/widgets/entry_tile.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class WorkspaceDetailPage extends StatelessWidget {
  const WorkspaceDetailPage({
    required this.workspaceId,
    required this.workspaceName,
    required this.loadEntries,
    required this.recordEntry,
    required this.estimator,
    super.key,
  });

  final String workspaceId;
  final String workspaceName;
  final UseCase<List<LedgerEntry>, String> loadEntries;
  final UseCase<LedgerEntry, RecordEntryParams> recordEntry;
  final LifeCostEstimator estimator;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionsCubit(workspaceId, loadEntries, recordEntry, estimator)..load(),
      child: _WorkspaceDetailView(workspaceId: workspaceId, workspaceName: workspaceName),
    );
  }
}

final class _WorkspaceDetailView extends StatelessWidget {
  const _WorkspaceDetailView({required this.workspaceId, required this.workspaceName});

  final String workspaceId;
  final String workspaceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(workspaceName)),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              EntryForm(
                previewText: _previewText(state),
                onPreview: (pesos) => context.read<TransactionsCubit>().previewLifeCost(pesos),
                onSubmit: (values) => context.read<TransactionsCubit>().record(
                  RecordEntryParams(
                    workspaceId: workspaceId,
                    kind: values.kind,
                    pesos: values.pesos,
                    description: values.description,
                    occurredOn: DateTime.now(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _StatusMessage(status: state.status),
              const SizedBox(height: 16),
              if (state.status == TransactionsStatus.loading && state.entries.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (state.entries.isEmpty)
                Text('transactions.empty'.tr(), textAlign: TextAlign.center)
              else
                for (final entry in state.entries) ...[
                  EntryTile(entry: entry),
                  const SizedBox(height: 8),
                ],
            ],
          );
        },
      ),
    );
  }

  String? _previewText(TransactionsState state) {
    final hours = state.previewHours;
    final days = state.previewDays;

    if (hours == null || days == null) {
      return null;
    }

    return 'transactions.preview'.tr(
      namedArgs: {
        'hours': NumberFormat('#,##0.##', 'es').format(hours),
        'days': NumberFormat('#,##0.##', 'es').format(days),
      },
    );
  }
}

final class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.status});

  final TransactionsStatus status;

  @override
  Widget build(BuildContext context) {
    final key = switch (status) {
      TransactionsStatus.recorded => 'transactions.messages.recorded',
      TransactionsStatus.invalidInput => 'transactions.errors.invalidInput',
      TransactionsStatus.networkError => 'transactions.errors.network',
      _ => null,
    };

    if (key == null) {
      return const SizedBox.shrink();
    }

    return Text(
      key.tr(),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: status == TransactionsStatus.recorded
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.error,
      ),
    );
  }
}
