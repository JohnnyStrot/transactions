import 'package:flutter/foundation.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/auth/auth_repository.dart';
import '../../../utils/result.dart';

class LogoutViewModel extends ChangeNotifier {
  LogoutViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    logout = Command.createAsyncNoParam(_logout, initialValue: Result.ok(null));
  }

  final AuthRepository _authRepository;
  final _log = Logger('LogoutViewModel');

  late Command<void, Result<void>> logout;

  Future<Result<void>> _logout() async {
    final result = await _authRepository.logout();
    if (result is Error<void>) {
      _log.warning('Logout failed! ${result.error}');
    } else {
      _log.info('Logout success');
    }
    return result;
  }
}
