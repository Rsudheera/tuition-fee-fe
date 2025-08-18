import '../models/tuition_class.dart';
import '../services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class ClassRepository {
  final ApiService _apiService = ApiService();

  Future<List<TuitionClass>> getClasses() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getClasses);
      final List<dynamic> classesJson = response['classes'] ?? [];
      return classesJson.map((json) => TuitionClass.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<TuitionClass> createClass(TuitionClass tuitionClass) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.createClass,
        tuitionClass.toJson(),
      );
      return TuitionClass.fromJson(response['class']);
    } catch (e) {
      rethrow;
    }
  }

  Future<TuitionClass> updateClass(TuitionClass tuitionClass) async {
    try {
      final response = await _apiService.put(
        '${ApiEndpoints.updateClass}/${tuitionClass.id}',
        tuitionClass.toJson(),
      );
      return TuitionClass.fromJson(response['class']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteClass(String classId) async {
    try {
      await _apiService.delete('${ApiEndpoints.deleteClass}/$classId');
    } catch (e) {
      rethrow;
    }
  }

  Future<TuitionClass> getClassById(String classId) async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.getClasses}/$classId',
      );
      return TuitionClass.fromJson(response['class']);
    } catch (e) {
      rethrow;
    }
  }
}
