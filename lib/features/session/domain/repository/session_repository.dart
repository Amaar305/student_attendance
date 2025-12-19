import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';

abstract interface class SessionRepository {
  // Sessions (Lecturer)
  /// If there is already an open session for this course, returns it.
  /// Otherwise creates a new open session and returns it.
  Future<Either<Failure, Session>> createOrGetOpenSession({
    required String courseId,
    required String lecturerId,
    required DateTime startAt,
    String? topic,
    int lateAfterMinutes = 10,
  });

  Future<Either<Failure, void>> closeSession({required String sessionId});

  Future<Either<Failure, List<Course>>> fetchLecturerCourses({
    required String lecturerId,
  });

  /// QR payload string the lecturer will render as QR code.
  /// Keep it simple and safe (contains sessionId + token).
  String buildQrPayload({required String sessionId, required String qrToken});
}
