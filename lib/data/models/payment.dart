enum PaymentStatus { pending, paid, overdue, cancelled }

class Payment {
  final String id;
  final String studentId;
  final String classId;
  final String teacherId;
  final double amount;
  final DateTime dueDate;
  final DateTime? paidDate;
  final PaymentStatus status;
  final String? notes;
  final String month; // e.g., "2024-01"
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.teacherId,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    this.status = PaymentStatus.pending,
    this.notes,
    required this.month,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPaid => status == PaymentStatus.paid;
  bool get isOverdue =>
      status == PaymentStatus.overdue ||
      (status == PaymentStatus.pending && DateTime.now().isAfter(dueDate));

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      classId: json['classId'] ?? '',
      teacherId: json['teacherId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      dueDate: DateTime.parse(
        json['dueDate'] ?? DateTime.now().toIso8601String(),
      ),
      paidDate: json['paidDate'] != null
          ? DateTime.parse(json['paidDate'])
          : null,
      status: _parsePaymentStatus(json['status']),
      notes: json['notes'],
      month: json['month'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  static PaymentStatus _parsePaymentStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return PaymentStatus.paid;
      case 'overdue':
        return PaymentStatus.overdue;
      case 'cancelled':
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'classId': classId,
      'teacherId': teacherId,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'status': status.name,
      'notes': notes,
      'month': month,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Payment copyWith({
    String? id,
    String? studentId,
    String? classId,
    String? teacherId,
    double? amount,
    DateTime? dueDate,
    DateTime? paidDate,
    PaymentStatus? status,
    String? notes,
    String? month,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      teacherId: teacherId ?? this.teacherId,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      month: month ?? this.month,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
