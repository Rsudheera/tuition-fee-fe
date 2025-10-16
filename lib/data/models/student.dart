class Enrollment {
  final String id;
  final String studentId;
  final String classId;
  final Map<String, dynamic>? classDetails;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Enrollment({
    required this.id,
    required this.studentId,
    required this.classId,
    this.classDetails,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      classId: json['classId'] ?? '',
      classDetails: json['class'],
      status: json['status'] ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class Student {
  final String id;
  final String fullName; // Changed to fullName from firstName + lastName
  final int? age;
  final String? parentName;
  final String? parentContactNumber;
  final bool isActive; // Using 'status' from API as 'isActive'
  final String? email;
  final String? phone;
  final String? address;
  final String? school;
  final String? grade;
  final String? teacherId;
  final List<String> classIds;
  final List<Enrollment> enrollments;
  final DateTime createdAt;
  final DateTime updatedAt;

  Student({
    required this.id,
    required this.fullName,
    this.age,
    this.parentName,
    this.parentContactNumber,
    required this.isActive,
    this.email,
    this.phone,
    this.address,
    this.school,
    this.grade,
    this.teacherId,
    this.classIds = const [],
    this.enrollments = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    // Check if data is nested under 'data' key
    final Map<String, dynamic> studentData =
        json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    // Extract teacher ID if teacher object exists
    String? extractedTeacherId;
    if (studentData['teacher'] is Map<String, dynamic>) {
      extractedTeacherId = studentData['teacher']['id'];
    }

    // Parse enrollments array
    List<Enrollment> enrollmentsList = [];
    if (studentData['enrollments'] is List) {
      enrollmentsList = (studentData['enrollments'] as List)
          .map((enrollmentJson) => Enrollment.fromJson(enrollmentJson))
          .toList();
    }

    return Student(
      id: studentData['id'] ?? '',
      fullName: studentData['fullName'] ?? '',
      age: studentData['age'] is int ? studentData['age'] : null,
      parentName: studentData['parentName'],
      parentContactNumber: studentData['parentContactNumber'],
      isActive: studentData['status'] ?? true,
      email: studentData['email'],
      phone: studentData['phone'],
      address: studentData['address'],
      school: studentData['school'],
      grade: studentData['grade'],
      teacherId: extractedTeacherId ?? studentData['teacherId'],
      classIds: parseClassIds(studentData['classIds']),
      enrollments: enrollmentsList,
      createdAt: DateTime.parse(
        studentData['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        studentData['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'age': age,
      'parentName': parentName,
      'parentContactNumber': parentContactNumber,
      'status': isActive,
      'email': email,
      'phone': phone,
      'address': address,
      'school': school,
      'grade': grade,
      'teacherId': teacherId,
      'classIds': classIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Student copyWith({
    String? id,
    String? fullName,
    int? age,
    String? parentName,
    String? parentContactNumber,
    bool? isActive,
    String? email,
    String? phone,
    String? address,
    String? school,
    String? grade,
    String? teacherId,
    List<String>? classIds,
    List<Enrollment>? enrollments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      parentName: parentName ?? this.parentName,
      parentContactNumber: parentContactNumber ?? this.parentContactNumber,
      isActive: isActive ?? this.isActive,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      school: school ?? this.school,
      grade: grade ?? this.grade,
      teacherId: teacherId ?? this.teacherId,
      classIds: classIds ?? this.classIds,
      enrollments: enrollments ?? this.enrollments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Helper method to check if student is enrolled in any classes
  bool get isEnrolled => enrollments.isNotEmpty;

  /// Helper method to get the count of active enrollments
  int get enrollmentCount => enrollments.where((e) => e.status).length;

  /// Helper method to get enrollment status text
  String get enrollmentStatus => isEnrolled ? 'Enrolled' : 'Not Enrolled';

  /// Helper method to get class names from enrollments
  List<String> get enrolledClassNames {
    return enrollments
        .where((e) => e.status && e.classDetails != null)
        .map((e) => e.classDetails!['name']?.toString() ?? 'Unknown Class')
        .toList();
  }

  /// Helper method to safely parse classIds from various potential formats
  static List<String> parseClassIds(dynamic classIdsData) {
    if (classIdsData == null) {
      return [];
    } else if (classIdsData is List) {
      return List<String>.from(classIdsData.map((item) => item.toString()));
    } else if (classIdsData is String) {
      // Handle case where a single class ID might be provided as a string
      return [classIdsData];
    }
    return [];
  }
}
