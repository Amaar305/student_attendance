import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class WatchSessionAttendanceCountUseCase
    implements UseCaseStream<int, WatchSessionAttendanceCountParams> {
  final LecturerRepository lecturerRepository;

  const WatchSessionAttendanceCountUseCase({required this.lecturerRepository});

  @override
  Stream<Either<Failure, int>> call(WatchSessionAttendanceCountParams param) {
    return lecturerRepository.watchSessionAttendanceCount(
      sessionId: param.sessionId,
    );
  }
}

class WatchSessionAttendanceCountParams {
  final String sessionId;

  const WatchSessionAttendanceCountParams({required this.sessionId});
}
