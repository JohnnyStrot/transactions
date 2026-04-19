import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:transactions/data/repositories/analysis/analysis_repository.dart';
import 'package:transactions/data/repositories/analysis/analysis_repository_remote.dart';
import 'package:transactions/data/repositories/auth/auth_repository.dart';
import 'package:transactions/data/repositories/auth/auth_repository_remote.dart';
import 'package:transactions/data/repositories/company/company_repository.dart';
import 'package:transactions/data/repositories/company/company_repository_remote.dart';
import 'package:transactions/data/repositories/product/product_repository.dart';
import 'package:transactions/data/repositories/product/product_repository_remote.dart';
import 'package:transactions/data/repositories/transaction/transaction_repository.dart';
import 'package:transactions/data/repositories/transaction/transaction_repository_remote.dart';
import 'package:transactions/data/repositories/transaction_partner/transaction_partner_repository.dart';
import 'package:transactions/data/repositories/transaction_partner/transaction_partner_repository_remote.dart';
import 'package:transactions/data/services/api/api_service.dart';
import 'package:transactions/data/services/api/auth_api_client.dart';

import 'main.dart';

/// Development config entry point.
/// Launch with `flutter run --target lib/main_development.dart`.
/// Uses development api.
void main() async {
  Logger.root.level = Level.ALL;

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => AuthApiClient()),
        ChangeNotifierProvider(
          create: (context) =>
              AuthRepositoryRemote(authApiClient: context.read())
                  as AuthRepository,
        ),
        Provider(
          create: (context) => ApiService(authApiClient: context.read()),
        ),
        Provider(
          create: (context) =>
              CompanyRepositoryRemote(apiService: context.read())
                  as CompanyRepository,
        ),
        Provider(
          create: (context) =>
              TransactionRepositoryRemote(apiService: context.read())
                  as TransactionRepository,
        ),
        Provider(
          create: (context) =>
              TransactionPartnerRepositoryRemote(apiService: context.read())
                  as TransactionPartnerRepository,
        ),
        Provider(
          create: (context) =>
              ProductRepositoryRemote(apiService: context.read())
                  as ProductRepository,
        ),
        Provider(
          create: (context) =>
              AnalysisRepositoryRemote(apiService: context.read())
                  as AnalysisRepository,
        ),
      ],
      child: const MainApp(),
    ),
  );
}
