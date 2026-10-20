import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/loans/domain/entities/loan.dart';
import 'package:money_app/features/loans/domain/entities/loan_draft.dart';
import 'package:money_app/features/loans/presentation/cubit/loans_cubit.dart';
import 'package:money_app/features/loans/presentation/cubit/loans_state.dart';
import 'package:money_app/features/loans/presentation/widgets/loan_form.dart';
import 'package:money_app/features/loans/presentation/widgets/loan_tile.dart';
import 'package:money_app/shared/base_domain/use_cases/no_params.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class LoansPage extends StatelessWidget {
  const LoansPage({
    required this.loadLoans,
    required this.createLoan,
    super.key,
  });

  final UseCase<List<Loan>, NoParams> loadLoans;
  final UseCase<Loan, LoanDraft> createLoan;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoansCubit(loadLoans, createLoan)..load(),
      child: const _LoansView(),
    );
  }
}

final class _LoansView extends StatelessWidget {
  const _LoansView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('loans.title'.tr())),
      body: BlocBuilder<LoansCubit, LoansState>(
        builder: (context, state) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            LoanForm(
              isLoading: state.status == LoansStatus.loading,
              onSubmit: (draft) => context.read<LoansCubit>().create(draft),
            ),
            const SizedBox(height: 16),
            _StatusMessage(status: state.status),
            if (state.status == LoansStatus.loading && state.loans.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (state.loans.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text('loans.empty'.tr(), textAlign: TextAlign.center),
              )
            else
              for (final loan in state.loans) LoanTile(loan: loan),
          ],
        ),
      ),
    );
  }
}

final class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.status});

  final LoansStatus status;

  @override
  Widget build(BuildContext context) {
    final key = switch (status) {
      LoansStatus.created => 'loans.messages.created',
      LoansStatus.invalidInput => 'loans.errors.invalidInput',
      LoansStatus.networkError => 'loans.errors.network',
      _ => null,
    };

    if (key == null) {
      return const SizedBox.shrink();
    }

    return Text(
      key.tr(),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: status == LoansStatus.created
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.error,
      ),
    );
  }
}
