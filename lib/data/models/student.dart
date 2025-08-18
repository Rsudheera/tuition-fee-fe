class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? parentPhone;
  final String? address;
  final String? school;
  final String grade;
  final String teacherId;
  final List<String> classIds;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.parentPhone,
    this.address,
    this.school,
    required this.grade,
    required this.teacherId,
    this.classIds = const [],
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      parentPhone: json['parentPhone'],
      address: json['address'],
      school: json['school'],
      grade: json['grade'] ?? '',
      teacherId: json['teacherId'] ?? '',
      classIds: List<String>.from(json['classIds'] ?? []),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'parentPhone': parentPhone,
      'address': address,
      'school': school,
      'grade': grade,
      'teacherId': teacherId,
      'classIds': classIds,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Student copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? parentPhone,
    String? address,
    String? school,
    String? grade,
    String? teacherId,
    List<String>? classIds,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      parentPhone: parentPhone ?? this.parentPhone,
      address: address ?? this.address,
      school: school ?? this.school,
      grade: grade ?? this.grade,
      teacherId: teacherId ?? this.teacherId,
      classIds: classIds ?? this.classIds,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
