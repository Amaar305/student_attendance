import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class WatchLecturerStudentsUseCase
    implements UseCaseStream<List<CourseStudent>, WatchLecturerStudentsParams> {
  final LecturerRepository lecturerRepository;

  const WatchLecturerStudentsUseCase({required this.lecturerRepository});

  @override
  Stream<Either<Failure, List<CourseStudent>>> call(
    WatchLecturerStudentsParams param,
  ) {
    return lecturerRepository.watchLecturerStudents(
      lecturerId: param.lecturerId,
    );
  }
}

class WatchLecturerStudentsParams {
  const WatchLecturerStudentsParams({required this.lecturerId});

  final String lecturerId;
}
