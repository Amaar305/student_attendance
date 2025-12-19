import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/session/session.dart';

class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl({required this.remoteDataSource});

  final SessionRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, Session>> createOrGetOpenSession({
    required String courseId,
    required String lecturerId,
    required DateTime startAt,
    String? topic,
    int lateAfterMinutes = 10,
  }) async {
    try {
      final session = await remoteDataSource.createOrGetOpenSession(
        courseId: courseId,
        lecturerId: lecturerId,
        startAt: startAt,
        topic: topic,
        lateAfterMinutes: lateAfterMinutes,
      );

      return Right(session);
    } on FirebaseException catch (error) {
      return Left(ServerFailure(error.message ?? 'Failed to open session'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> closeSession({
    required String sessionId,
  }) async {
    try {
      await remoteDataSource.closeSession(sessionId: sessionId);

      return right(null);
    } on FirebaseException catch (error) {
      return Left(ServerFailure(error.message ?? 'Failed to close session'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Course>>> fetchLecturerCourses({
    required String lecturerId,
  }) async {
    try {
      final courses = await remoteDataSource.fetchLecturerCourses(
        lecturerId: lecturerId,
      );

      return Right(courses);
    } on FirebaseException catch (error) {
      return Left(ServerFailure(error.message ?? 'Failed to load courses'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  String buildQrPayload({required String sessionId, required String qrToken}) {
    return remoteDataSource.buildQrPayload(
      sessionId: sessionId,
      qrToken: qrToken,
    );
  }
}
