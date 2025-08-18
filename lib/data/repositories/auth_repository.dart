import '../models/teacher.dart';
import '../services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post(ApiEndpoints.login, {
        'email': email,
        'password': password,
      });

      if (response['token'] != null) {
        _apiService.setAuthToken(response['token']);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await _apiService.post(ApiEndpoints.register, {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'phone': phone,
      });

      if (response['token'] != null) {
        _apiService.setAuthToken(response['token']);
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
      _apiService.clearAuthToken();
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
