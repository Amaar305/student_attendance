import 'package:shared/shared.dart';

class StudentAttendanceItem {
  const StudentAttendanceItem({
    required this.sessionId,
    required this.courseId,
    required this.courseTitle,
    required this.timestamp,
    required this.status,
    required this.sessionStart,
  });

  final String sessionId;
  final String courseId;
  final String courseTitle;
  final DateTime timestamp;
  final AttendanceStatus status;
  final DateTime sessionStart;
}

// TODO Implement this library.
