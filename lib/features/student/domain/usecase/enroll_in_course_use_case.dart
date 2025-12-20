import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

class EnrollInCourseUseCase implements UseCase<void, EnrollInCourseParams> {
  const EnrollInCourseUseCase(this._studentRepository);

  final StudentRepository _studentRepository;

  @override
  Future<Either<Failure, void>> call(EnrollInCourseParams param) {
    return _studentRepository.enrollInCourse(
      courseId: param.courseId,
      studentId: param.studentId,
      courseTitle: param.courseTitle,
    );
  }
}

class EnrollInCourseParams {
  const EnrollInCourseParams({
    required this.courseId,
    required this.courseTitle,
    required this.studentId,
  });

  final String courseId;
  final String courseTitle;
  final String studentId;
}
