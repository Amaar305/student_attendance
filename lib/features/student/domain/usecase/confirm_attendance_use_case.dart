import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

class ConfirmAttendanceUseCase
    implements UseCase<AttendanceRecord, ConfirmAttendanceParams> {
  const ConfirmAttendanceUseCase(this._studentRepository);

  final StudentRepository _studentRepository;

  @override
  Future<Either<Failure, AttendanceRecord>> call(
    ConfirmAttendanceParams param,
  ) {
    return _studentRepository.confirmAttendance(
      studentId: param.studentId,
      qrPayload: param.qrPayload,
      now: param.now,
    );
  }
}

class ConfirmAttendanceParams {
  const ConfirmAttendanceParams({
    required this.studentId,
    required this.qrPayload,
    this.now,
  });

  final String studentId;
  final String qrPayload;
  final DateTime? now;
}
