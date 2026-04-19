import 'dart:convert';
import 'dart:typed_data';

import 'package:transactions/data/services/api/auth_api_client.dart';
import 'package:transactions/utils/result.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiService {
  ApiService({required AuthApiClient authApiClient})
    : _authApiClient = authApiClient;

  final AuthApiClient _authApiClient;
  static const String _baseUrl = String.fromEnvironment(
    'backend_url',
    defaultValue: 'http://localhost:4003',
  );

  Future<http.Response> get(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    var token = await _authApiClient.getAccessToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }
    Uri uri = Uri.parse('$_baseUrl/$endpoint');
    if (params != null) {
      uri = Uri(
        scheme: uri.scheme,
        fragment: uri.fragment,
        host: uri.host,
        path: uri.path,
        port: uri.port,
        userInfo: uri.userInfo,
        queryParameters: params.map(
          (k, v) => v is Iterable<String>
              ? MapEntry(k, v)
              : MapEntry(k, v.toString()),
        ),
      );
    }

    var response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // If token expired (server returns 403)
    if (response.statusCode == 403) {
      final refreshResult = await _authApiClient.refreshTokens();
      switch (refreshResult) {
        case Ok<void>():
          token = await _authApiClient.getAccessToken();
          // Retry the request with new token
          response = await http.get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );
        case Error<void>():
          // Refresh failed, user must log in again
          throw Exception('Session expired, please log in again.');
      }
    }

    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    var token = await _authApiClient.getAccessToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    var response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 403) {
      final refreshResult = await _authApiClient.refreshTokens();
      switch (refreshResult) {
        case Ok<void>():
          token = await _authApiClient.getAccessToken();
          // Retry the request with new token
          response = await http.post(
            Uri.parse('$_baseUrl/$endpoint'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          );
        case Error<void>():
          // Refresh failed, user must log in again
          throw Exception('Session expired, please log in again.');
      }
    }

    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    var token = await _authApiClient.getAccessToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    var response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 403) {
      final refreshResult = await _authApiClient.refreshTokens();
      switch (refreshResult) {
        case Ok<void>():
          token = await _authApiClient.getAccessToken();
          // Retry the request with new token
          response = await http.put(
            Uri.parse('$_baseUrl/$endpoint'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          );
        case Error<void>():
          // Refresh failed, user must log in again
          throw Exception('Session expired, please log in again.');
      }
    }

    return response;
  }

  Future<http.Response> delete(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    var token = await _authApiClient.getAccessToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    var response = await http.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 403) {
      final refreshResult = await _authApiClient.refreshTokens();
      switch (refreshResult) {
        case Ok<void>():
          token = await _authApiClient.getAccessToken();
          // Retry the request with new token
          response = await http.delete(
            Uri.parse('$_baseUrl/$endpoint'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          );
        case Error<void>():
          // Refresh failed, user must log in again
          throw Exception('Session expired, please log in again.');
      }
    }

    return response;
  }

  Future<Result<void>> downloadEndpoint(
    String endpoint,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
  }) async {
    return download(
      "$_baseUrl/$endpoint",
      savePath,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Result<void>> download(
    String urlPath,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
  }) async {
    final refreshResult = await _authApiClient.refreshTokens();
    switch (refreshResult) {
      case Ok<void>():
        var token = await _authApiClient.getAccessToken();
        await Dio().download(
          urlPath,
          savePath,
          onReceiveProgress: onReceiveProgress,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );
        return Result<void>.ok(null);
      case Error<void>():
        // Refresh failed, user must log in again
        return Result<void>.error(
          Exception('Session expired, please log in again.'),
        );
    }
  }

  Future<Result<void>> launchEndpoint(String endpoint) async {
    return launch(Uri.parse('$_baseUrl/$endpoint'));
  }

  Future<Result<void>> launch(Uri uri) async {
    final refreshResult = await _authApiClient.refreshTokens();
    switch (refreshResult) {
      case Ok<void>():
        var token = await _authApiClient.getAccessToken();
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: WebViewConfiguration(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );
        return Result<void>.ok(null);
      case Error<void>():
        // Refresh failed, user must log in again
        return Result<void>.error(
          Exception('Session expired, please log in again.'),
        );
    }
  }

  Future<Result<void>> deleteImage(String endpoint, String file) async {
    try {
      var res = await delete(endpoint, {"file": file});
      if (res.statusCode == 200) {
        return Result.ok(null);
      }
      return Result.error(Exception("Status code ${res.statusCode} returned"));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> uploadImage(String endpoint, XFile image) async {
    final refreshResult = await _authApiClient.refreshTokens();
    switch (refreshResult) {
      case Ok<void>():
        var token = await _authApiClient.getAccessToken();

        try {
          var dioRequest = Dio();
          dioRequest.options.baseUrl = _baseUrl;

          dioRequest.options.headers = {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/x-www-form-urlencoded',
          };

          var formData = FormData();

          final Uint8List bytes = await image.readAsBytes();
          MultipartFile file = MultipartFile.fromBytes(
            bytes,
            filename: image.name,
            contentType: DioMediaType("image", image.name),
          );

          formData.files.add(MapEntry('file', file));

          var response = await dioRequest.post(
            "$_baseUrl/$endpoint",
            data: formData,
          );
          if (response.statusCode == 200) {
            return Result.ok(response.data["file"]);
          }
          return Result.error(
            Exception("Status code ${response.statusCode} was returned"),
          );
        } on Exception catch (err) {
          return Result.error(err);
        }
      case Error<void>():
        // Refresh failed, user must log in again
        return Result<String?>.error(
          Exception('Session expired, please log in again.'),
        );
    }
  }

  Future<Result<List<String>>> uploadImages(
    String endpoint,
    List<XFile> images,
  ) async {
    final refreshResult = await _authApiClient.refreshTokens();
    switch (refreshResult) {
      case Ok<void>():
        var token = await _authApiClient.getAccessToken();

        try {
          var dioRequest = Dio();
          dioRequest.options.baseUrl = _baseUrl;

          dioRequest.options.headers = {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/x-www-form-urlencoded',
          };

          var formData = FormData();

          for (var image in images) {
            final Uint8List bytes = await image.readAsBytes();
            MultipartFile file = MultipartFile.fromBytes(
              bytes,
              filename: image.name,
              contentType: DioMediaType("image", image.name),
            );

            formData.files.add(MapEntry("file", file));
          }

          var response = await dioRequest.post(
            "$_baseUrl/$endpoint",
            data: formData,
          );
          if (response.data["files"] == null) {
            return Result.error(Exception("No file names returned"));
          }
          if (response.statusCode == 200) {
            return Result.ok(
              (response.data["files"] as List<dynamic>)
                  .map((c) => c as String)
                  .toList(),
            );
          }
          return Result.error(
            Exception("Status code ${response.statusCode} was returned"),
          );
        } on Exception catch (err) {
          return Result.error(err);
        }
      case Error<void>():
        // Refresh failed, user must log in again
        return Result<List<String>>.error(
          Exception('Session expired, please log in again.'),
        );
    }
  }
}
