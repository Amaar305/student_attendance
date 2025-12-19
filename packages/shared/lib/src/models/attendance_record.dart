// ignore_for_file: public_member_api_docs

class AttendanceRecord {
  const AttendanceRecord({
    required this.sessionId,
    required this.courseId,
    required this.studentId,
    required this.timestamp,
    required this.status,
  });

  final String sessionId;
  final String courseId;
  final String studentId;
  final DateTime timestamp;
  final AttendanceStatus status;
}

enum AttendanceStatus { present, late }
