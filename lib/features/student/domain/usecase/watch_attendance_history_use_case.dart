import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

class WatchAttendanceHistoryUseCase
    implements
        UseCaseStream<
          List<StudentAttendanceItem>,
          WatchAttendanceHistoryParams
        > {
  final StudentRepository studentRepository;

  const WatchAttendanceHistoryUseCase({required this.studentRepository});

  @override
  Stream<Either<Failure, List<StudentAttendanceItem>>> call(
    WatchAttendanceHistoryParams param,
  ) => studentRepository.watchAttendanceHistory(
    studentId: param.studentId,
    from: param.from,
    to: param.to,
  );
}

class WatchAttendanceHistoryParams {
  final String studentId;
  final DateTime from;
  final DateTime to;
  final String? courseId;

  const WatchAttendanceHistoryParams({
    required this.studentId,
    required this.from,
    required this.to,
    required this.courseId,
  });
}
