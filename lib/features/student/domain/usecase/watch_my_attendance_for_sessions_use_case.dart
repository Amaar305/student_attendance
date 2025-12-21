import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

class WatchMyAttendanceForSessionsUseCase
    implements
        UseCaseStream<
          Map<String, AttendanceStatus>,
          WatchMyAttendanceForSessionsParams
        > {
  final StudentRepository studentRepository;

  const WatchMyAttendanceForSessionsUseCase({required this.studentRepository});

  @override
  Stream<Either<Failure, Map<String, AttendanceStatus>>> call(
    WatchMyAttendanceForSessionsParams param,
  ) => studentRepository.watchMyAttendanceForSessions(
    studentId: param.studentId,
    sessionIds: param.sessionIds,
  );
}

class WatchMyAttendanceForSessionsParams {
  final String studentId;
  final List<String> sessionIds;

  const WatchMyAttendanceForSessionsParams({
    required this.studentId,
    required this.sessionIds,
  });
}
