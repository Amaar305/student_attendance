import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class AddCourseUseCase implements UseCase<void, AddCourseParams> {
  final LecturerRepository lecturerRepository;

  const AddCourseUseCase({required this.lecturerRepository});

  @override
  Future<Either<Failure, void>> call(AddCourseParams param) async {
    return await lecturerRepository.addCourse(
      lecturerId: param.lecturerId,
      code: param.code,
      name: param.name,
      level: param.level,
    );
  }
}

class AddCourseParams {
  final String lecturerId;
  final String code;
  final String name;
  final String level;

  const AddCourseParams({
    required this.lecturerId,
    required this.code,
    required this.name,
    required this.level,
  });
}
