import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'data/repositories/auth/auth_repository.dart';
import 'data/repositories/auth/auth_repository_remote.dart';
import 'data/services/api/auth_api_client.dart';
import 'main.dart';

/// Staging config entry point.
/// Launch with `flutter run --target lib/main_staging.dart`.
/// Uses remote data from a server.
void main() {
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
      ],
      child: const MainApp(),
    ),
  );
}
