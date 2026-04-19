import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/auth/auth_repository.dart';
import '../../../utils/result.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    login = Command.createAsyncNoParam(_login, initialValue: Result.ok(null));
  }

  final AuthRepository _authRepository;
  final _log = Logger('LoginViewModel');

  late Command<void, Result<void>> login;

  Future<Result<void>> _login() async {
    final result = await _authRepository.login();
    if (result is Error<void>) {
      _log.warning('Login failed! ${result.error}');
    } else {
      _log.info('Login success');
    }
    return result;
  }
}
