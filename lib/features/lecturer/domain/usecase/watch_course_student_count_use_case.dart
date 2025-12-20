import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class WatchCourseStudentCountUseCase
    implements UseCaseStream<int, WatchCourseStudentCountParams> {
  final LecturerRepository lecturerRepository;

  const WatchCourseStudentCountUseCase({required this.lecturerRepository});

  @override
  Stream<Either<Failure, int>> call(WatchCourseStudentCountParams param) {
    return lecturerRepository.watchCourseStudentCount(courseId: param.courseId);
  }
}

class WatchCourseStudentCountParams {
  final String courseId;

  const WatchCourseStudentCountParams({required this.courseId});
}
