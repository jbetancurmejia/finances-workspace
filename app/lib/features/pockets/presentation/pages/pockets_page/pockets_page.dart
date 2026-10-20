import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/pockets/domain/entities/add_member_params.dart';
import 'package:money_app/features/pockets/domain/entities/pocket.dart';
import 'package:money_app/features/pockets/presentation/cubit/pockets_cubit.dart';
import 'package:money_app/features/pockets/presentation/cubit/pockets_state.dart';
import 'package:money_app/features/pockets/presentation/widgets/add_member_dialog.dart';
import 'package:money_app/features/pockets/presentation/widgets/pocket_create_form.dart';
import 'package:money_app/features/pockets/presentation/widgets/pocket_tile.dart';
import 'package:money_app/shared/base_domain/use_cases/no_params.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class PocketsPage extends StatelessWidget {
  const PocketsPage({
    required this.loadPockets,
    required this.createPocket,
    required this.addMember,
    required this.lifeCostBuilder,
    required this.loansBuilder,
    required this.workspaceBuilder,
    super.key,
  });

  final UseCase<List<Pocket>, NoParams> loadPockets;
  final UseCase<Pocket, String> createPocket;
  final UseCase<void, AddMemberParams> addMember;
  final WidgetBuilder lifeCostBuilder;
  final WidgetBuilder loansBuilder;
  final Widget Function(BuildContext context, Pocket pocket) workspaceBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PocketsCubit(loadPockets, createPocket, addMember)..load(),
      child: _PocketsView(
        lifeCostBuilder: lifeCostBuilder,
        loansBuilder: loansBuilder,
        workspaceBuilder: workspaceBuilder,
      ),
    );
  }
}

final class _PocketsView extends StatelessWidget {
  const _PocketsView({
    required this.lifeCostBuilder,
    required this.loansBuilder,
    required this.workspaceBuilder,
  });

  final WidgetBuilder lifeCostBuilder;
  final WidgetBuilder loansBuilder;
  final Widget Function(BuildContext context, Pocket pocket) workspaceBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pockets.title'.tr()),
        actions: [
          IconButton(
            tooltip: 'pockets.lifeCostTooltip'.tr(),
            icon: const Icon(Icons.hourglass_bottom),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: lifeCostBuilder)),
          ),
          IconButton(
            tooltip: 'loans.title'.tr(),
            icon: const Icon(Icons.account_balance),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: loansBuilder)),
          ),
        ],
      ),
      body: BlocBuilder<PocketsCubit, PocketsState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PocketCreateForm(
                  onSubmit: (name) => context.read<PocketsCubit>().create(name),
                ),
                const SizedBox(height: 16),
                _StatusMessage(status: state.status),
                Expanded(
                  child: _PocketList(
                    state: state,
                    workspaceBuilder: workspaceBuilder,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

final class _PocketList extends StatelessWidget {
  const _PocketList({required this.state, required this.workspaceBuilder});

  final PocketsState state;
  final Widget Function(BuildContext context, Pocket pocket) workspaceBuilder;

  @override
  Widget build(BuildContext context) {
    if (state.status == PocketsStatus.loading && state.pockets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.pockets.isEmpty) {
      return Center(
        child: Text('pockets.empty'.tr(), textAlign: TextAlign.center),
      );
    }

    return ListView.separated(
      itemCount: state.pockets.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final pocket = state.pockets[index];

        return PocketTile(
          pocket: pocket,
          onOpen: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (ctx) => workspaceBuilder(ctx, pocket),
            ),
          ),
          onAddMember: () => _promptForMember(context, pocket),
        );
      },
    );
  }

  Future<void> _promptForMember(BuildContext context, Pocket pocket) async {
    final cubit = context.read<PocketsCubit>();
    final email = await showDialog<String>(
      context: context,
      builder: (_) => const AddMemberDialog(),
    );

    if (email == null || email.isEmpty) {
      return;
    }

    await cubit.addMember(pocket.id, email);
  }
}

final class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.status});

  final PocketsStatus status;

  @override
  Widget build(BuildContext context) {
    final key = switch (status) {
      PocketsStatus.memberAdded => 'pockets.messages.memberAdded',
      PocketsStatus.memberNotFound => 'pockets.errors.memberNotFound',
      PocketsStatus.memberAlreadyAdded => 'pockets.errors.memberAlreadyAdded',
      PocketsStatus.invalidInput => 'pockets.errors.invalidInput',
      PocketsStatus.networkError => 'pockets.errors.network',
      _ => null,
    };

    if (key == null) {
      return const SizedBox.shrink();
    }

    final isError = status != PocketsStatus.memberAdded;

    return Text(
      key.tr(),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
