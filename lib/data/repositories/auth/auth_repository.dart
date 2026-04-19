import 'package:flutter/foundation.dart';

import '../../../utils/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  /// Returns true when the user is logged in
  /// Returns [Future] because it will load a stored auth state the first time.
  Future<bool> get isAuthenticated;
  Future<bool> get isLoading;

  /// Perform login
  Future<Result<void>> login();

  /// Perform logout
  Future<Result<void>> logout();
}
