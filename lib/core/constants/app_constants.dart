class AppConstants {
  // App Information
  static const String appName = 'Tuition Fee Manager';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://your-backend-url.com/api';
  static const String apiVersion = 'v1';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';

  // Timeout Durations
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Default Values
  static const int defaultPageSize = 20;
  static const String defaultCurrency = 'LKR';
}
