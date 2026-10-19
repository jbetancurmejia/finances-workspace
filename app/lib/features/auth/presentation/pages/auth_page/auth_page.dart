import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/auth/domain/entities/auth_session.dart';
import 'package:money_app/features/auth/domain/entities/credentials.dart';
import 'package:money_app/features/auth/domain/entities/registration.dart';
import 'package:money_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:money_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:money_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:money_app/shared/base_domain/use_cases/use_case.dart';

final class AuthPage extends StatelessWidget {
  const AuthPage({
    required this.login,
    required this.register,
    required this.homeBuilder,
    super.key,
  });

  final UseCase<AuthSession, Credentials> login;
  final UseCase<AuthSession, Registration> register;
  final WidgetBuilder homeBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(login, register),
      child: _AuthView(homeBuilder: homeBuilder),
    );
  }
}

final class _AuthView extends StatelessWidget {
  const _AuthView({required this.homeBuilder});

  final WidgetBuilder homeBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('auth.title'.tr())),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: homeBuilder),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthForm(
                  isLoading: state.status == AuthStatus.loading,
                  onLogin: (credentials) => context.read<AuthCubit>().login(credentials),
                  onRegister: (registration) => context.read<AuthCubit>().register(registration),
                ),
                const SizedBox(height: 16),
                _StatusMessage(status: state.status),
              ],
            ),
          );
        },
      ),
    );
  }
}

final class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.status});

  final AuthStatus status;

  @override
  Widget build(BuildContext context) {
    final key = switch (status) {
      AuthStatus.invalidCredentials => 'auth.errors.invalidCredentials',
      AuthStatus.emailTaken => 'auth.errors.emailTaken',
      AuthStatus.invalidInput => 'auth.errors.invalidInput',
      AuthStatus.networkError => 'auth.errors.network',
      _ => null,
    };

    if (key == null) {
      return const SizedBox.shrink();
    }

    return Text(
      key.tr(),
      textAlign: TextAlign.center,
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    );
  }
}
