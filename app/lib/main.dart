import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:money_app/app.dart';
import 'package:money_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:money_app/features/auth/data/repositories/auth_data_repository.dart';
import 'package:money_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:money_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:money_app/features/auth/presentation/pages/auth_page/auth_page.dart';
import 'package:money_app/features/life_cost/data/datasources/life_cost_remote_datasource.dart';
import 'package:money_app/features/life_cost/data/repositories/life_cost_data_repository.dart';
import 'package:money_app/features/life_cost/domain/use_cases/load_life_cost_use_case.dart';
import 'package:money_app/features/life_cost/presentation/pages/life_cost_page/life_cost_page.dart';
import 'package:money_app/shared/base_data/network/api_client.dart';
import 'package:money_app/shared/base_data/network/api_config.dart';
import 'package:money_app/shared/base_data/network/auth_token_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final tokenStore = AuthTokenStore();
  final client = createApiClient(baseUrl: apiBaseUrl, tokenStore: tokenStore);

  final authRepository = AuthDataRepository(AuthHttpDatasource(client), tokenStore);
  final loadLifeCost = LoadLifeCostUseCase(
    LifeCostDataRepository(LifeCostHttpDatasource(client)),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('es'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('es'),
      child: MoneyApp(
        home: AuthPage(
          login: LoginUseCase(authRepository),
          register: RegisterUseCase(authRepository),
          homeBuilder: (_) => LifeCostPage(loadLifeCost: loadLifeCost),
        ),
      ),
    ),
  );
}
