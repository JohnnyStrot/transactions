import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transactions/data/repositories/auth/auth_repository.dart';
import 'package:transactions/ui/analysis/analysis_page.dart';
import 'package:transactions/ui/analysis/analysis_viewmodel.dart';
import 'package:transactions/ui/auth/login/login_viewmodel.dart';
import 'package:transactions/ui/company/company_details.dart';
import 'package:transactions/ui/company/company_details_viewmodel.dart';
import 'package:transactions/ui/company/company_list.dart';
import 'package:transactions/ui/company/company_list_viewmodel.dart';
import 'package:transactions/ui/dashboard/dashboard.dart';
import 'package:transactions/ui/dashboard/dashboard_viewmodel.dart';
import 'package:transactions/ui/product/product_details_viewmodel.dart';
import 'package:transactions/ui/product/product_details.dart';
import 'package:transactions/ui/product/product_list.dart';
import 'package:transactions/ui/product/product_list_viewmodel.dart';
import 'package:transactions/ui/transaction/transaction_details.dart';
import 'package:transactions/ui/transaction/transaction_details_viewmodel.dart';
import 'package:transactions/ui/transaction/transaction_list.dart';
import 'package:transactions/ui/transaction/transaction_list_viewmodel.dart';
import 'package:transactions/ui/transaction_partner/transaction_partner_details.dart';
import 'package:transactions/ui/transaction_partner/transaction_partner_details_viewmodel.dart';
import 'package:transactions/ui/transaction_partner/transaction_partner_list.dart';
import 'package:transactions/ui/transaction_partner/transaction_partner_list_viewmodel.dart';

import '../ui/auth/login/login_screen.dart';
import '../ui/navigation/main_screen.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final dataRoutes = [
  GoRoute(
    path: Routes.transactionPartnersRelative,
    builder: (context, state) {
      final viewModel = TransactionPartnerListViewmodel(
        transactionPartnerRepository: context.read(),
      );
      return TransactionPartnerList(viewmodel: viewModel);
    },
    routes: [
      GoRoute(
        path: Routes.createRelative,
        builder: (context, state) {
          TransactionPartnerDetailsViewmodel vm =
              TransactionPartnerDetailsViewmodel(
                transactionPartnerRepository: context.read(),
              );
          vm.createEntity.execute();
          return TransactionPartnerDetails(viewmodel: vm);
        },
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final vm = TransactionPartnerDetailsViewmodel(
            transactionPartnerRepository: context.read(),
          );

          vm.loadEntity.execute(id);

          return TransactionPartnerDetails(viewmodel: vm);
        },
      ),
    ],
  ),
  GoRoute(
    path: Routes.productsRelative,
    builder: (context, state) {
      final viewModel = ProductListViewmodel(productRepository: context.read());
      return ProductList(viewmodel: viewModel);
    },
    routes: [
      GoRoute(
        path: Routes.createRelative,
        builder: (context, state) {
          ProductDetailsViewmodel vm = ProductDetailsViewmodel(
            productRepository: context.read(),
          );
          vm.createEntity.execute();

          return ProductDetails(viewmodel: vm);
        },
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final vm = ProductDetailsViewmodel(productRepository: context.read());

          vm.loadEntity.execute(id);

          return ProductDetails(viewmodel: vm);
        },
      ),
    ],
  ),
  GoRoute(
    path: Routes.companiesRelative,
    builder: (context, state) {
      final viewModel = CompanyListViewmodel(companyRepository: context.read());
      return CompanyList(viewmodel: viewModel);
    },
    routes: [
      GoRoute(
        path: Routes.createRelative,
        builder: (context, state) {
          CompanyDetailsViewmodel vm = CompanyDetailsViewmodel(
            companyRepository: context.read(),
          );
          vm.createEntity.execute();
          return CompanyDetails(viewmodel: vm);
        },
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final vm = CompanyDetailsViewmodel(companyRepository: context.read());

          vm.loadEntity.execute(id);

          return CompanyDetails(viewmodel: vm);
        },
      ),
    ],
  ),
  GoRoute(
    path: Routes.transactionsRelative,
    builder: (context, state) {
      final viewModel = TransactionListViewmodel(
        transactionRepository: context.read(),
      );
      return TransactionList(viewmodel: viewModel);
    },
    routes: [
      GoRoute(
        path: Routes.createRelative,
        builder: (context, state) {
          TransactionDetailsViewmodel vm = TransactionDetailsViewmodel(
            transactionRepository: context.read(),
          );
          vm.createEntity.execute();
          return TransactionDetails(viewmodel: vm);
        },
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final vm = TransactionDetailsViewmodel(
            transactionRepository: context.read(),
          );

          vm.loadEntity.execute(id);

          return TransactionDetails(viewmodel: vm);
        },
      ),
    ],
  ),
];

final analysisRoute = GoRoute(
  path: Routes.analysis,
  builder: (context, state) {
    final viewModel = AnalysisViewmodel(repository: context.read());
    return AnalysisPage(viewmodel: viewModel);
  },
  routes: [],
);

GoRouter router(AuthRepository authRepository) => GoRouter(
  refreshListenable: authRepository,
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.dashboard,
  debugLogDiagnostics: true,
  redirect: _redirect,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(child: MainScreen(child: child));
      },
      routes: [
        GoRoute(
          path: Routes.dashboard,
          builder: (context, state) => Dashboard(
            viewmodel: DashboardViewmodel(repository: context.read()),
          ),
        ),
        GoRoute(
          path: Routes.data,
          builder: (context, state) {
            return Placeholder();
          },
          routes: dataRoutes,
        ),
        analysisRoute,
      ],
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return LoginScreen(
          viewModel: LoginViewModel(authRepository: context.read()),
        );
      },
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.login;
  if (!loggedIn) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to
  // the home page
  if (loggingIn) {
    return Routes.dashboard;
  }

  // no need to redirect at all
  return null;
}
