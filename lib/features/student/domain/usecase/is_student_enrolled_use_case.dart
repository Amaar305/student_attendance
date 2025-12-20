import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';


class IsStudentEnrolledUseCase
    implements UseCase<bool, IsStudentEnrolledParams> {
  const IsStudentEnrolledUseCase(this._studentRepository);

  final StudentRepository _studentRepository;

  @override
  Future<Either<Failure, bool>> call(IsStudentEnrolledParams param) {
    return _studentRepository.isStudentEnrolled(
      courseId: param.courseId,
      studentId: param.studentId,
    );
  }
}
class IsStudentEnrolledParams {
  const IsStudentEnrolledParams({
    required this.courseId,
    required this.studentId,
  });

  final String courseId;
  final String studentId;
}
