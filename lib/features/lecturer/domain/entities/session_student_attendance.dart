import 'package:shared/shared.dart';

class SessionStudentAttendance {
  const SessionStudentAttendance({
    required this.student,
    this.status,
    this.checkedInAt,
  });

  final AppUser student;
  final AttendanceStatus? status;
  final DateTime? checkedInAt;

  bool get isPresent => status != null;
}
