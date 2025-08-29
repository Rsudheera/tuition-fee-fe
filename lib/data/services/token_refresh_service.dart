import 'dart:async';
import '../services/api_service.dart';
import '../services/token_storage_service.dart';
import '../../core/constants/api_endpoints.dart';

class TokenRefreshService {
  static final TokenRefreshService _instance = TokenRefreshService._internal();
  factory TokenRefreshService() => _instance;
  TokenRefreshService._internal();

  final ApiService _apiService = ApiService();
  final TokenStorageService _tokenStorageService = TokenStorageService();
  Timer? _refreshTimer;

  /// Start periodic token refresh
  void startTokenRefresh() {
    // Cancel any existing timer
    _refreshTimer?.cancel();

    // Refresh token every 23 hours (assuming token expires in 24 hours)
    _refreshTimer = Timer.periodic(const Duration(hours: 23), (_) {
      refreshToken();
    });
  }

  /// Stop token refresh
  void stopTokenRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Refresh the authentication token
  Future<bool> refreshToken() async {
    try {
      final currentToken = await _tokenStorageService.getToken();

      if (currentToken == null || currentToken.isEmpty) {
        return false;
      }

      final response = await _apiService.post(ApiEndpoints.refreshToken, {});

      if (response['success'] == true &&
          response['data'] != null &&
          response['data']['access_token'] != null) {
        final newToken = response['data']['access_token'];
        await _apiService.setAuthToken(newToken);
        return true;
      }
      return false;
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }
}
