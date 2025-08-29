import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class TokenStorageService {
  static final TokenStorageService _instance = TokenStorageService._internal();
  factory TokenStorageService() => _instance;
  TokenStorageService._internal();

  /// Saves the JWT token to persistent storage
  Future<bool> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(AppConstants.authTokenKey, token);
    } catch (e) {
      print('Error saving token: $e');
      return false;
    }
  }

  /// Retrieves the JWT token from persistent storage
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.authTokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  /// Removes the JWT token from persistent storage
  Future<bool> deleteToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(AppConstants.authTokenKey);
    } catch (e) {
      print('Error deleting token: $e');
      return false;
    }
  }

  /// Checks if a token exists in storage
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
