import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

abstract interface class StudentRepository {
  // Search
  Stream<Either<Failure, List<CourseSearchItem>>> watchCourses({
    String? search,
  });

  // Enroll
  Future<Either<Failure, void>> enrollInCourse({
    required CourseSearchItem course,
    required String studentId,
  });

  Future<Either<Failure, bool>> isStudentEnrolled({
    required String courseId,
    required String studentId,
  });

  // Student home
  Stream<Either<Failure, List<String>>> watchEnrolledCourseIds({
    required String studentId,
  });

  /// Returns today's sessions for the student's enrolled courses.
  Stream<Either<Failure, List<Session>>> watchTodaySessionsForStudent({
    required String studentId,
    required DateTime dayStart,
    required DateTime dayEnd,
  });

  // QR scan preview (no write yet)
  Future<Either<Failure, ScanPreview>> getScanPreview({
    required String qrPayload,
  });

  // Confirm attendance (writes)
  Future<Either<Failure, AttendanceRecord>> confirmAttendance({
    required String studentId,
    required String qrPayload,
    DateTime? now,
  });

  Stream<Either<Failure, List<StudentAttendanceItem>>> watchAttendanceHistory({
    required String studentId,
    required DateTime from,
    required DateTime to,
    String? courseId,
  });

  Stream<Either<Failure, List<EnrollmentCourseOption>>>
  watchStudentCourseOptions({required String studentId});

  /// Fast lookup of attendance by sessionId(s) using the student's mirror collection.
  Stream<Either<Failure, Map<String, AttendanceStatus>>>
  watchMyAttendanceForSessions({
    required String studentId,
    required List<String> sessionIds,
  });
}
