import 'package:transactions/data/repositories/auth/auth_repository.dart';
import 'package:transactions/data/services/api/auth_api_client.dart';
import 'package:transactions/utils/result.dart';
import 'package:logging/logging.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({required AuthApiClient authApiClient})
    : _authApiClient = authApiClient;

  final _log = Logger('AuthRepositoryRemote');

  final AuthApiClient _authApiClient;

  bool _isLoading = false;

  @override
  Future<bool> get isAuthenticated =>
      Future.value(_authApiClient.oidcManager.currentUser != null);

  @override
  Future<bool> get isLoading => Future.value(_isLoading);

  @override
  Future<Result<void>> login() async {
    _isLoading = true;
    notifyListeners();

    final result = await _authApiClient.login();
    if (result is Error<void>) {
      _log.severe(result.error);
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  @override
  Future<Result<void>> logout() async {
    _isLoading = true;
    notifyListeners();
    final result = await _authApiClient.logout();
    if (result is Error<void>) {
      _log.severe(result.error);
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }
}
