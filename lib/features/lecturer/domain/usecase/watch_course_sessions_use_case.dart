import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class WatchCourseSessionsUseCase
    implements UseCaseStream<List<Session>, WatchCourseSessionsParams> {
  final LecturerRepository lecturerRepository;

  const WatchCourseSessionsUseCase({required this.lecturerRepository});

  @override
  Stream<Either<Failure, List<Session>>> call(WatchCourseSessionsParams param) {
    return lecturerRepository.watchCourseSessions(courseId: param.courseId);
  }
}

class WatchCourseSessionsParams {
  final String courseId;

  const WatchCourseSessionsParams({required this.courseId});
}
