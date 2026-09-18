import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';

import '../../../utils/result.dart';

class AuthApiClient {
  static const String _clientId = String.fromEnvironment(
    'auth_client_id',
    defaultValue: 'transactions',
  );
  static const List<String> _scopes = ['openid', 'offline_access'];
  static const String _issuer = String.fromEnvironment(
    'auth_issuer',
    defaultValue: 'https://johnnyst.de:8443/realms/applications',
  );
  static const String _redirectUrlMobile =
      'de.johnnyst.transactions://callback';
  static const String _redirectUrlWeb = String.fromEnvironment(
    'redirect_url_web',
    defaultValue: 'http://localhost:22433/redirect.html',
  );

  static const managerId = "transactions";

  final FlutterSecureStorage _secureStorage;
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _idTokenKey = 'id_token';

  OidcPlatformSpecificOptions_Web_NavigationMode webNavigationMode =
      OidcPlatformSpecificOptions_Web_NavigationMode.newPage;

  bool allowInsecureConnections = false;
  OidcAppAuthExternalUserAgent externalUserAgent =
      OidcAppAuthExternalUserAgent.asWebAuthenticationSession;

  OidcPlatformSpecificOptions _getOptions() {
    return OidcPlatformSpecificOptions(
      web: OidcPlatformSpecificOptions_Web(
        navigationMode: webNavigationMode,
        popupHeight: 800,
        popupWidth: 730,
      ),
      // these settings are from https://pub.dev/packages/flutter_appauth.
      android: OidcPlatformSpecificOptions_AppAuth_Android(
        allowInsecureConnections: allowInsecureConnections,
      ),
      ios: OidcPlatformSpecificOptions_AppAuth_IosMacos(
        externalUserAgent: externalUserAgent,
      ),
      macos: OidcPlatformSpecificOptions_AppAuth_IosMacos(
        externalUserAgent: externalUserAgent,
      ),
      windows: const OidcPlatformSpecificOptions_Native(),
      linux: OidcPlatformSpecificOptions_Native(),
    );
  }

  late OidcUserManager oidcManager;

  AuthApiClient() : _secureStorage = FlutterSecureStorage() {
    oidcManager = OidcUserManager.lazy(
      id: managerId,
      discoveryDocumentUri: OidcUtils.getOpenIdConfigWellKnownUri(
        Uri.parse(_issuer),
      ),
      clientCredentials: const OidcClientAuthentication.none(
        clientId: _clientId,
      ),
      store: OidcDefaultStore(secureStorageInstance: _secureStorage),
      keyStore: JsonWebKeyStore(),
      settings: OidcUserManagerSettings(
        uiLocales: ["de"],
        refreshBefore: (token) {
          return const Duration(seconds: 1);
        },
        scope: _scopes,
        postLogoutRedirectUri: kIsWeb
            ? Uri.parse(_redirectUrlWeb)
            : Platform.isAndroid || Platform.isIOS || Platform.isMacOS
            ? Uri.parse(_redirectUrlMobile)
            : Platform.isWindows || Platform.isLinux
            ? Uri.parse('http://localhost:0')
            : null,
        redirectUri: kIsWeb
            // this url must be an actual html page.
            // see the file in /web/redirect.html for an example.
            //
            // for debugging in flutter, you must run this app with --web-port 22433
            ? Uri.parse(_redirectUrlWeb)
            : Platform.isIOS || Platform.isMacOS || Platform.isAndroid
            // scheme: reverse domain name notation of your package name.
            // path: anything.
            ? Uri.parse(_redirectUrlMobile)
            : Platform.isWindows || Platform.isLinux
            // using port 0 means that we don't care which port is used,
            // and a random unused port will be assigned.
            //
            // this is safer than passing a port yourself.
            //
            // note that you can also pass a path like /redirect,
            // but it's completely optional.
            ? Uri.parse('http://localhost:0')
            : Uri(),
      ),
    );
  }

  Future<void> init() async {
    if (oidcManager.didInit) {
      return;
    }
    await oidcManager.init();

    return;
  }

  Future<Result<void>> login() async {
    debugPrint("Logging in");
    try {
      var res = await oidcManager.loginAuthorizationCodeFlow(
        options: _getOptions(),
      );
      if (res != null) {
        return Result.ok(null);
      } else {
        return Result.error(Exception("Login failed"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<String?> getAccessToken() async {
    return Future.value("a");
    return oidcManager.currentUser?.token.accessToken;
  }

  Future<Result<void>> logout() async {
    debugPrint("Logging out");
    try {
      await oidcManager.logout();
      await oidcManager.forgetUser();
      return Result.ok(null);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Result.error(e);
    }
  }

  Future<void> writeToken(OidcToken token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token.accessToken);
    await _secureStorage.write(
      key: _refreshTokenKey,
      value: token.refreshToken,
    );
    await _secureStorage.write(key: _idTokenKey, value: token.idToken);
  }

  Future<Result<void>> refreshTokens() async {
    var a = await oidcManager.refreshToken();
    if (a == null) {
      return Result.error(Exception("Token not refreshed"));
    }
    return Result.ok(null);
  }
}
