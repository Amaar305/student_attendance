import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';

abstract interface class AttendanceRepository {
  // Courses (Lecturer)
  Future<Either<Failure, String>> createCourse({
    required String lecturerId,
    required String code,
    required String name,
  });
  Stream<Either<Failure, List<Course>>> watchLecturerCourses({
    required String lecturerId,
  });

  /// Enrollment (Student)
  Future<Either<Failure, void>> enrollInCourse({
    required String courseId,
    required String studentId,
  });

  Future<Either<Failure, bool>> isStudentEnrolled({
    required String courseId,
    required String studentId,
  });
}
