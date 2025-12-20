import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class WatchLecturerCoursesUseCase
    implements UseCaseStream<List<Course>, WatchLecturerCoursesParams> {
  final LecturerRepository lecturerRepository;

  const WatchLecturerCoursesUseCase({required this.lecturerRepository});

  @override
  Stream<Either<Failure, List<Course>>> call(
    WatchLecturerCoursesParams param,
  ) {
    return lecturerRepository.watchLecturerCourses(
      lecturerId: param.lecturerId,
    );
  }
}

class WatchLecturerCoursesParams {
  const WatchLecturerCoursesParams({required this.lecturerId});

  final String lecturerId;
}
