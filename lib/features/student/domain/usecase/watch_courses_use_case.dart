import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

class WatchCoursesUseCase
    implements UseCaseStream<List<CourseSearchItem>, WatchCoursesParams> {
  final StudentRepository _studentRepository;

  WatchCoursesUseCase({required StudentRepository studentRepository})
    : _studentRepository = studentRepository;

  @override
  Stream<Either<Failure, List<CourseSearchItem>>> call(
    WatchCoursesParams params,
  ) {
    return _studentRepository.watchCourses(search: params.search);
  }
}

class WatchCoursesParams {
  final String? search;

  const WatchCoursesParams({this.search});
}
