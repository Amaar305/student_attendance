import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class GetCourseStudentCountUseCase
    implements UseCase<int, GetCourseStudentCountParams> {
  final LecturerRepository lecturerRepository;

  const GetCourseStudentCountUseCase({required this.lecturerRepository});

  @override
  Future<Either<Failure, int>> call(GetCourseStudentCountParams param) async {
    return await lecturerRepository.getCourseStudentCount(
      courseId: param.courseId,
    );
  }
}

class GetCourseStudentCountParams {
  final String courseId;

  const GetCourseStudentCountParams({required this.courseId});
}
