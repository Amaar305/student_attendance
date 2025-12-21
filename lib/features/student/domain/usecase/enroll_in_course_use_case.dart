import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

class EnrollInCourseUseCase implements UseCase<void, EnrollInCourseParams> {
  const EnrollInCourseUseCase(this._studentRepository);

  final StudentRepository _studentRepository;

  @override
  Future<Either<Failure, void>> call(EnrollInCourseParams param) {
    return _studentRepository.enrollInCourse(
      studentId: param.studentId,
      course: param.course,
    );
  }
}

class EnrollInCourseParams {
  const EnrollInCourseParams({required this.studentId, required this.course});

  final CourseSearchItem course;
  final String studentId;
}
