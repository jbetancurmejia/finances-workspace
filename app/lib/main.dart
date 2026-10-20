import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:money_app/app.dart';
import 'package:money_app/composition/life_cost_estimator_adapter.dart';
import 'package:money_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:money_app/features/auth/data/repositories/auth_data_repository.dart';
import 'package:money_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:money_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:money_app/features/auth/presentation/pages/auth_page/auth_page.dart';
import 'package:money_app/features/life_cost/data/datasources/life_cost_remote_datasource.dart';
import 'package:money_app/features/life_cost/data/repositories/life_cost_data_repository.dart';
import 'package:money_app/features/life_cost/domain/use_cases/load_life_cost_use_case.dart';
import 'package:money_app/features/life_cost/presentation/pages/life_cost_page/life_cost_page.dart';
import 'package:money_app/features/loans/data/datasources/loan_remote_datasource.dart';
import 'package:money_app/features/loans/data/repositories/loan_data_repository.dart';
import 'package:money_app/features/loans/domain/use_cases/create_loan_use_case.dart';
import 'package:money_app/features/loans/domain/use_cases/load_loans_use_case.dart';
import 'package:money_app/features/loans/presentation/pages/loans_page/loans_page.dart';
import 'package:money_app/features/pockets/data/datasources/pocket_remote_datasource.dart';
import 'package:money_app/features/pockets/data/repositories/pocket_data_repository.dart';
import 'package:money_app/features/pockets/domain/use_cases/add_pocket_member_use_case.dart';
import 'package:money_app/features/pockets/domain/use_cases/create_pocket_use_case.dart';
import 'package:money_app/features/pockets/domain/use_cases/load_pockets_use_case.dart';
import 'package:money_app/features/pockets/presentation/pages/pockets_page/pockets_page.dart';
import 'package:money_app/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:money_app/features/transactions/data/repositories/transaction_data_repository.dart';
import 'package:money_app/features/transactions/domain/use_cases/load_entries_use_case.dart';
import 'package:money_app/features/transactions/domain/use_cases/record_entry_use_case.dart';
import 'package:money_app/features/transactions/presentation/pages/workspace_detail_page/workspace_detail_page.dart';
import 'package:money_app/shared/base_data/network/api_client.dart';
import 'package:money_app/shared/base_data/network/api_config.dart';
import 'package:money_app/shared/base_data/network/auth_token_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final tokenStore = AuthTokenStore();
  final client = createApiClient(baseUrl: apiBaseUrl, tokenStore: tokenStore);

  final authRepository = AuthDataRepository(
    AuthHttpDatasource(client),
    tokenStore,
  );
  final pocketRepository = PocketDataRepository(PocketHttpDatasource(client));
  final transactionRepository = TransactionDataRepository(
    TransactionHttpDatasource(client),
  );
  final loanRepository = LoanDataRepository(LoanHttpDatasource(client));
  final loadLifeCost = LoadLifeCostUseCase(
    LifeCostDataRepository(LifeCostHttpDatasource(client)),
  );
  final estimator = LifeCostEstimatorAdapter(loadLifeCost);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('es'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('es'),
      child: MoneyApp(
        home: AuthPage(
          login: LoginUseCase(authRepository),
          register: RegisterUseCase(authRepository),
          homeBuilder: (_) => PocketsPage(
            loadPockets: LoadPocketsUseCase(pocketRepository),
            createPocket: CreatePocketUseCase(pocketRepository),
            addMember: AddPocketMemberUseCase(pocketRepository),
            lifeCostBuilder: (_) => LifeCostPage(loadLifeCost: loadLifeCost),
            loansBuilder: (_) => LoansPage(
              loadLoans: LoadLoansUseCase(loanRepository),
              createLoan: CreateLoanUseCase(loanRepository),
            ),
            workspaceBuilder: (_, pocket) => WorkspaceDetailPage(
              workspaceId: pocket.id,
              workspaceName: pocket.name,
              loadEntries: LoadEntriesUseCase(transactionRepository),
              recordEntry: RecordEntryUseCase(transactionRepository),
              estimator: estimator,
            ),
          ),
        ),
      ),
    ),
  );
}
