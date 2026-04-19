import '../../../utils/result.dart';
import 'auth_repository.dart';

class AuthRepositoryDev extends AuthRepository {
  bool _isAuthenticated = false;

  /// User is always authenticated in dev scenarios
  @override
  Future<bool> get isAuthenticated => Future.value(_isAuthenticated);

  /// Login is always successful in dev scenarios
  @override
  Future<Result<void>> login() async {
    _isAuthenticated = true;
    notifyListeners();
    return const Result.ok(null);
  }

  /// Logout is always successful in dev scenarios
  @override
  Future<Result<void>> logout() async {
    _isAuthenticated = false;
    notifyListeners();
    return const Result.ok(null);
  }

  @override
  Future<bool> get isLoading => Future.value(false);
}
