import '../models/student.dart';
import '../services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class StudentRepository {
  final ApiService _apiService = ApiService();

  Future<List<Student>> getStudents() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getStudents);
      print('API Response for students: $response'); // For debugging

      // Handle different potential response formats
      List<dynamic> studentsJson = [];

      if (response.containsKey('data')) {
        if (response['data'] is List) {
          // Format: {"success": true, "data": [student1, student2...]}
          studentsJson = List<dynamic>.from(response['data']);
        } else if (response['data'] is Map) {
          if (response['data'].containsKey('students') &&
              response['data']['students'] is List) {
            // Format: {"data": {"students": [student1, student2...]}}
            studentsJson = List<dynamic>.from(
              response['data']['students'] ?? [],
            );
          } else {
            // Format: {"success": true, "data": {student_details}} - Single student
            // Create a one-element list with the single student
            studentsJson = [response];
          }
        }
      } else if (response.containsKey('students')) {
        // Format: {"students": [student1, student2...]}
        studentsJson = List<dynamic>.from(response['students'] ?? []);
      } else {
        // If nothing matches, assume the response itself might contain valid data
        print('Response format not recognized, attempting to use raw data');
        studentsJson = [];
      }

      return studentsJson.map((json) => Student.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching students: $e');
      rethrow;
    }
  }

  Future<Student> createStudent(Student student) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.createStudent,
        student.toJson(),
      );
      return Student.fromJson(response['student']);
    } catch (e) {
      print('API error during student creation: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createStudentDirect({
    required String fullName,
    required String parentContactNumber,
    int? age,
    String? parentName,
  }) async {
    try {
      print('Creating student directly via repository');
      final Map<String, dynamic> requestBody = {
        'fullName': fullName,
        'age': age,
        'parentName': parentName,
        'parentContactNumber': parentContactNumber,
      };

      print('Sending request body: $requestBody');
      final response = await _apiService.post(
        ApiEndpoints.createStudent,
        requestBody,
      );
      print('Student created successfully: $response');
      return response;
    } catch (e) {
      print('Failed to create student: $e');
      throw Exception('Failed to create student: $e');
    }
  }

  Future<Student> updateStudent(Student student) async {
    try {
      final response = await _apiService.put(
        '${ApiEndpoints.updateStudent}/${student.id}',
        student.toJson(),
      );
      return Student.fromJson(response['student']);
    } catch (e) {
      print('API error during student update: $e');
      rethrow;
    }
  }

  Future<bool> deleteStudent(String id) async {
    try {
      await _apiService.delete('${ApiEndpoints.deleteStudent}/$id');
      return true;
    } catch (e) {
      print('API error during student deletion: $e');
      rethrow;
    }
  }

  Future<bool> toggleStudentStatus(String id, bool isActive) async {
    try {
      final response = await _apiService.put(
        '${ApiEndpoints.updateStudent}/$id/status',
        {'isActive': isActive},
      );
      return response['success'] ?? false;
    } catch (e) {
      print('API error during student status update: $e');
      rethrow;
    }
  }

  Future<bool> assignStudentToClass(String studentId, String classId) async {
    try {
      print('Assigning student $studentId to class $classId');
      final response = await _apiService.post(
        ApiEndpoints.assignStudentToClass,
        {'studentId': studentId, 'classId': classId},
      );
      print('Assignment response: $response');
      return response['success'] ?? false;
    } catch (e) {
      print('API error during student assignment: $e');
      rethrow;
    }
  }

  Future<bool> removeStudentFromClass(String studentId, String classId) async {
    try {
      // Get the current student
      final student = await _apiService.get(
        '${ApiEndpoints.getStudents}/$studentId',
      );
      final updatedClassIds = List<String>.from(student['classIds'] ?? [])
        ..remove(classId);

      // Update the student with new class list
      final response = await _apiService.put(
        '${ApiEndpoints.updateStudent}/$studentId',
        {'classIds': updatedClassIds},
      );
      return response['success'] ?? false;
    } catch (e) {
      print('API error during student removal from class: $e');
      rethrow;
    }
  }
}
