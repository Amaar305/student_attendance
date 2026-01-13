import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/domain/entities/session_student_attendance.dart';

abstract interface class LecturerRepository {
  Stream<Either<Failure, List<Course>>> watchLecturerCourses({
    required String lecturerId,
  });

  Stream<Either<Failure, int>> watchSessionAttendanceCount({
    required String sessionId,
  });

  Stream<Either<Failure, List<Session>>> watchCourseSessions({
    required String courseId,
  });

  Stream<Either<Failure, int>> watchCourseStudentCount({
    required String courseId,
  }); // preferred

  Future<Either<Failure, int>> getCourseStudentCount({
    required String courseId,
  });

  Future<Either<Failure, List<SessionStudentAttendance>>>
  getSessionStudentAttendance({
    required String courseId,
    required String sessionId,
  });

  Future<Either<Failure, void>> addCourse({
    required String lecturerId,
    required String code,
    required String name,
    required String level,
  });
}
