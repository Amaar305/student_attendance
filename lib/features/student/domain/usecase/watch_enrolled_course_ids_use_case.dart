import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';


class WatchEnrolledCourseIdsUseCase
    implements UseCaseStream<List<String>, WatchEnrolledCourseIdsParams> {
  const WatchEnrolledCourseIdsUseCase(this._studentRepository);

  final StudentRepository _studentRepository;

  @override
  Stream<Either<Failure, List<String>>> call(
    WatchEnrolledCourseIdsParams param,
  ) {
    return _studentRepository.watchEnrolledCourseIds(
      studentId: param.studentId,
    );
  }
}

class WatchEnrolledCourseIdsParams {
  const WatchEnrolledCourseIdsParams({required this.studentId});

  final String studentId;
}
