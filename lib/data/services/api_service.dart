import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import 'token_storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = AppConstants.baseUrl;
  final TokenStorageService _tokenStorageService = TokenStorageService();
  String? _authToken;

  Future<void> setAuthToken(String token) async {
    _authToken = token;
    // Store token securely using the token storage service
    await _tokenStorageService.saveToken(token);
  }

  Future<void> clearAuthToken() async {
    _authToken = null;
    // Remove token from secure storage
    await _tokenStorageService.deleteToken();
  }

  Future<Map<String, String>> get _headers async {
    final headers = {'Content-Type': 'application/json'};

    // If token is not in memory, try to load it from storage
    if (_authToken == null) {
      _authToken = await _tokenStorageService.getToken();
    }

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _headers;
      final response = await http
          .get(url, headers: headers)
          .timeout(Duration(milliseconds: AppConstants.connectionTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _headers;
      final response = await http
          .post(url, headers: headers, body: jsonEncode(data))
          .timeout(Duration(milliseconds: AppConstants.connectionTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _headers;
      final response = await http
          .put(url, headers: headers, body: jsonEncode(data))
          .timeout(Duration(milliseconds: AppConstants.connectionTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _headers;
      final response = await http
          .delete(url, headers: headers)
          .timeout(Duration(milliseconds: AppConstants.connectionTimeout));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      try {
        return jsonDecode(responseBody);
      } catch (e) {
        return {'message': 'Success'};
      }
    } else {
      try {
        final errorBody = jsonDecode(responseBody);
        throw ApiException(
          message: errorBody['message'] ?? 'An error occurred',
          statusCode: statusCode,
        );
      } catch (e) {
        throw ApiException(
          message: 'HTTP $statusCode: ${response.reasonPhrase}',
          statusCode: statusCode,
        );
      }
    }
  }

  Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }
    return ApiException(message: error.toString(), statusCode: 0);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
