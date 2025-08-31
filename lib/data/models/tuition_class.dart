class TuitionClass {
  final String id;
  final String name;
  final String? subject;
  final String description;
  final double monthlyFee;
  final int? paymentDueDay; // Made nullable
  final String? usualScheduledOn; // For the schedule (Monday 4 to 6 pm)
  final bool status;
  final Map<String, dynamic>? teacher;

  // These fields may not be in the API but are kept for compatibility
  final String? teacherId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? maxStudents;
  final int? currentStudents;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TuitionClass({
    required this.id,
    required this.name,
    this.subject,
    required this.description,
    required this.monthlyFee,
    this.paymentDueDay, // Made optional
    this.usualScheduledOn,
    required this.status,
    this.teacher,
    this.teacherId,
    this.startDate,
    this.endDate,
    this.maxStudents,
    this.currentStudents,
    this.createdAt,
    this.updatedAt,
  });

  bool get hasAvailableSlots => (currentStudents != null && maxStudents != null)
      ? currentStudents! < maxStudents!
      : false;

  int get availableSlots => (currentStudents != null && maxStudents != null)
      ? maxStudents! - currentStudents!
      : 0;

  // Helper getter for accessing teacher info
  String get teacherName => teacher != null
      ? teacher!['name'] ?? 'Unknown Teacher'
      : 'Unknown Teacher';

  factory TuitionClass.fromJson(Map<String, dynamic> json) {
    // Parse monthlyFee which could be a string or double
    double parsedMonthlyFee;
    if (json['monthlyFee'] is String) {
      parsedMonthlyFee = double.tryParse(json['monthlyFee'] ?? '0') ?? 0.0;
    } else {
      parsedMonthlyFee = (json['monthlyFee'] ?? 0).toDouble();
    }

    // Extract teacherId from teacher object if available
    String? extractedTeacherId;
    if (json['teacher'] is Map<String, dynamic>) {
      extractedTeacherId = json['teacher']['id']?.toString();
    }

    return TuitionClass(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subject: json['subject'],
      description: json['description'] ?? '',
      monthlyFee: parsedMonthlyFee,
      paymentDueDay: json['paymentDueDay'],
      usualScheduledOn: json['usualScheduledOn'],
      status: json['status'] ?? true,
      teacher: json['teacher'] is Map
          ? json['teacher'] as Map<String, dynamic>
          : null,
      teacherId: extractedTeacherId,
      // Keep these for backward compatibility
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      maxStudents: json['maxStudents'],
      currentStudents: json['currentStudents'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'name': name,
      'subject': subject,
      'description': description,
      'monthlyFee': monthlyFee,
      'status': status,
    };

    // Add optional fields only if they're not null
    if (paymentDueDay != null) json['paymentDueDay'] = paymentDueDay;
    if (usualScheduledOn != null) json['usualScheduledOn'] = usualScheduledOn;

    // Add optional fields if they exist
    if (teacherId != null) json['teacherId'] = teacherId;
    if (startDate != null) json['startDate'] = startDate!.toIso8601String();
    if (endDate != null) json['endDate'] = endDate!.toIso8601String();
    if (maxStudents != null) json['maxStudents'] = maxStudents;
    if (currentStudents != null) json['currentStudents'] = currentStudents;
    if (createdAt != null) json['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) json['updatedAt'] = updatedAt!.toIso8601String();

    return json;
  }

  TuitionClass copyWith({
    String? id,
    String? name,
    String? subject,
    String? description,
    double? monthlyFee,
    int? paymentDueDay,
    String? usualScheduledOn,
    bool? status,
    Map<String, dynamic>? teacher,
    String? teacherId,
    DateTime? startDate,
    DateTime? endDate,
    int? maxStudents,
    int? currentStudents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TuitionClass(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      paymentDueDay: paymentDueDay ?? this.paymentDueDay,
      usualScheduledOn: usualScheduledOn ?? this.usualScheduledOn,
      status: status ?? this.status,
      teacher: teacher ?? this.teacher,
      teacherId: teacherId ?? this.teacherId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxStudents: maxStudents ?? this.maxStudents,
      currentStudents: currentStudents ?? this.currentStudents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
