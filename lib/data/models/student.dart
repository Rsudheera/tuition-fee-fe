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
      classIds: List<String>.from(studentData['classIds'] ?? []),
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
