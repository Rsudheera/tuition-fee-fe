import '../models/teacher.dart';
import '../services/api_service.dart';
import '../services/token_storage_service.dart';
import '../../core/constants/api_endpoints.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final TokenStorageService _tokenStorageService = TokenStorageService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post(ApiEndpoints.login, {
        'email': email,
        'password': password,
      });

      // New response format handling
      if (response['success'] == true && response['data'] != null) {
        if (response['data']['access_token'] != null) {
          final token = response['data']['access_token'];
          await _apiService.setAuthToken(token);
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String businessName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await _apiService.post(ApiEndpoints.register, {
        'name': name,
        'businessName': businessName,
        'email': email,
        'password': password,
        'phone': phone,
      });

      // New response format handling
      if (response['success'] == true && response['data'] != null) {
        if (response['data']['access_token'] != null) {
          final token = response['data']['access_token'];
          await _apiService.setAuthToken(token);
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post(ApiEndpoints.logout, {});
    } catch (e) {
      // Handle logout errors if needed
    } finally {
      await _apiService.clearAuthToken();
    }
  }

  Future<Teacher> getProfile() async {
    try {
      final response = await _apiService.get(ApiEndpoints.teacherProfile);
      return Teacher.fromJson(response['teacher']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Teacher> updateProfile(Teacher teacher) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.updateTeacher,
        teacher.toJson(),
      );
      return Teacher.fromJson(response['teacher']);
    } catch (e) {
      rethrow;
    }
  }
}
