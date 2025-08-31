class ApiEndpoints {
  // Base endpoints
  static const String auth = '/auth';
  static const String teachers = '/teachers';
  static const String classes = '/class';
  static const String students = '/students';
  static const String payments = '/payments';

  // Auth endpoints
  static const String login = '/teacher/login';
  static const String register = '/teacher/register';
  static const String logout = '$auth/logout';
  static const String refreshToken = '$auth/refresh';

  // Teacher endpoints
  static const String teacherProfile = '$teachers/profile';
  static const String updateTeacher = '$teachers/update';

  // Class endpoints
  static const String createClass = '$classes/create';
  static const String createClassDirect = classes;
  static const String getClasses = classes;
  static const String updateClass = '$classes/update';
  static const String deleteClass = '$classes/delete';

  // Student endpoints
  static const String createStudent = '$students/create';
  static const String getStudents = students;
  static const String updateStudent = '$students/update';
  static const String deleteStudent = '$students/delete';
  static const String assignStudentToClass = '$students/assign-class';

  // Payment endpoints
  static const String createPayment = '$payments/create';
  static const String getPayments = payments;
  static const String getPaymentsByStudent = '$payments/student';
  static const String getPaymentsByClass = '$payments/class';
  static const String updatePaymentStatus = '$payments/status';
}
