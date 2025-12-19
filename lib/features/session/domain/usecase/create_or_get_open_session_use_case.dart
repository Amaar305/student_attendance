import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';

import '../repository/session_repository.dart';

class CreateOrGetOpenSessionUseCase
    implements UseCase<Session, CreateOrGetOpenSessionParams> {
  const CreateOrGetOpenSessionUseCase(this._sessionRepository);

  final SessionRepository _sessionRepository;

  @override
  Future<Either<Failure, Session>> call(CreateOrGetOpenSessionParams param) {
    return _sessionRepository.createOrGetOpenSession(
      courseId: param.courseId,
      lecturerId: param.lecturerId,
      startAt: param.startAt,
      topic: param.topic,
      lateAfterMinutes: param.lateAfterMinutes,
    );
  }
}

class CreateOrGetOpenSessionParams {
  const CreateOrGetOpenSessionParams({
    required this.courseId,
    required this.lecturerId,
    required this.startAt,
    this.topic,
    this.lateAfterMinutes = 10,
  });

  final String courseId;
  final String lecturerId;
  final DateTime startAt;
  final String? topic;
  final int lateAfterMinutes;
}
