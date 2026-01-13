import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/domain/entities/session_student_attendance.dart';
import 'package:student_attendance/features/lecturer/domain/repository/lecturer_repository.dart';

class GetSessionStudentAttendanceUseCase
    implements
        UseCase<List<SessionStudentAttendance>,
            GetSessionStudentAttendanceParams> {
  const GetSessionStudentAttendanceUseCase({
    required this.lecturerRepository,
  });

  final LecturerRepository lecturerRepository;

  @override
  Future<Either<Failure, List<SessionStudentAttendance>>> call(
    GetSessionStudentAttendanceParams param,
  ) {
    return lecturerRepository.getSessionStudentAttendance(
      courseId: param.courseId,
      sessionId: param.sessionId,
    );
  }
}

class GetSessionStudentAttendanceParams {
  const GetSessionStudentAttendanceParams({
    required this.courseId,
    required this.sessionId,
  });

  final String courseId;
  final String sessionId;
}
