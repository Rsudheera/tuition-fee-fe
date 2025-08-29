import '../services/api_service.dart';
import '../services/token_storage_service.dart';
import '../services/token_refresh_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  final TokenStorageService _tokenStorageService = TokenStorageService();
  final TokenRefreshService _tokenRefreshService = TokenRefreshService();

  /// Initialize auth state when app starts
  Future<bool> initializeAuth() async {
    try {
      final token = await _tokenStorageService.getToken();
      if (token != null && token.isNotEmpty) {
        // Set the token in the API service
        await _apiService.setAuthToken(token);

        // Start token refresh mechanism
        _tokenRefreshService.startTokenRefresh();
        return true;
      }
      return false;
    } catch (e) {
      print('Error initializing auth: $e');
      return false;
    }
  }

  /// Login successful - start token refresh
  void onLoginSuccess() {
    _tokenRefreshService.startTokenRefresh();
  }

  /// Logout - stop token refresh
  void onLogout() {
    _tokenRefreshService.stopTokenRefresh();
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _tokenStorageService.hasToken();
  }

  /// Get the current auth token
  Future<String?> getToken() async {
    return await _tokenStorageService.getToken();
  }
}
