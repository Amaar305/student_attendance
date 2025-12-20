import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

class WatchStudentCourseOptionsUseCase
    implements
        UseCaseStream<
          List<EnrollmentCourseOption>,
          WatchStudentCourseOptionsParams
        > {
  const WatchStudentCourseOptionsUseCase(this._studentRepository);

  final StudentRepository _studentRepository;

  @override
  Stream<Either<Failure, List<EnrollmentCourseOption>>> call(
    WatchStudentCourseOptionsParams param,
  ) {
    return _studentRepository.watchStudentCourseOptions(
      studentId: param.studentId,
    );
  }
}

class WatchStudentCourseOptionsParams {
  final String studentId;

  const WatchStudentCourseOptionsParams({required this.studentId});
}
