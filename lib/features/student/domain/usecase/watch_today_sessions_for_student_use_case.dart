import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';


class WatchTodaySessionsForStudentUseCase
    implements
        UseCaseStream<List<Session>, WatchTodaySessionsForStudentParams> {
  const WatchTodaySessionsForStudentUseCase(this._studentRepository);

  final StudentRepository _studentRepository;

  @override
  Stream<Either<Failure, List<Session>>> call(
    WatchTodaySessionsForStudentParams param,
  ) {
    return _studentRepository.watchTodaySessionsForStudent(
      studentId: param.studentId,
      dayStart: param.dayStart,
      dayEnd: param.dayEnd,
    );
  }
}

class WatchTodaySessionsForStudentParams {
  const WatchTodaySessionsForStudentParams({
    required this.studentId,
    required this.dayStart,
    required this.dayEnd,
  });

  final String studentId;
  final DateTime dayStart;
  final DateTime dayEnd;
}
