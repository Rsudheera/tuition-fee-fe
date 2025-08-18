class TuitionClass {
  final String id;
  final String name;
  final String subject;
  final String description;
  final double monthlyFee;
  final String teacherId;
  final DateTime startDate;
  final DateTime? endDate;
  final String schedule; // e.g., "Monday, Wednesday, Friday - 4:00 PM"
  final int maxStudents;
  final int currentStudents;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  TuitionClass({
    required this.id,
    required this.name,
    required this.subject,
    required this.description,
    required this.monthlyFee,
    required this.teacherId,
    required this.startDate,
    this.endDate,
    required this.schedule,
    required this.maxStudents,
    this.currentStudents = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get hasAvailableSlots => currentStudents < maxStudents;
  int get availableSlots => maxStudents - currentStudents;

  factory TuitionClass.fromJson(Map<String, dynamic> json) {
    return TuitionClass(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      monthlyFee: (json['monthlyFee'] ?? 0).toDouble(),
      teacherId: json['teacherId'] ?? '',
      startDate: DateTime.parse(
        json['startDate'] ?? DateTime.now().toIso8601String(),
      ),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      schedule: json['schedule'] ?? '',
      maxStudents: json['maxStudents'] ?? 0,
      currentStudents: json['currentStudents'] ?? 0,
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
      'name': name,
      'subject': subject,
      'description': description,
      'monthlyFee': monthlyFee,
      'teacherId': teacherId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'schedule': schedule,
      'maxStudents': maxStudents,
      'currentStudents': currentStudents,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  TuitionClass copyWith({
    String? id,
    String? name,
    String? subject,
    String? description,
    double? monthlyFee,
    String? teacherId,
    DateTime? startDate,
    DateTime? endDate,
    String? schedule,
    int? maxStudents,
    int? currentStudents,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TuitionClass(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      teacherId: teacherId ?? this.teacherId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      schedule: schedule ?? this.schedule,
      maxStudents: maxStudents ?? this.maxStudents,
      currentStudents: currentStudents ?? this.currentStudents,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
