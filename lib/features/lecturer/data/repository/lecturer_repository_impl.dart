import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class LecturerRepositoryImpl implements LecturerRepository {
  final LecturerRemoteDataSource lecturerRemoteDataSource;

  LecturerRepositoryImpl({required this.lecturerRemoteDataSource});

  @override
  Stream<Either<Failure, List<Course>>> watchLecturerCourses({
    required String lecturerId,
  }) async* {
    try {
      await for (final courses in lecturerRemoteDataSource.watchLecturerCourses(
        lecturerId: lecturerId,
      )) {
        yield right(courses);
      }
    } on FirebaseException catch (error) {
      yield Left(ServerFailure(error.message ?? 'Failed to load courses'));
    } catch (error) {
      yield Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getCourseStudentCount({
    required String courseId,
  }) async {
    try {
      final courses = await lecturerRemoteDataSource.getCourseStudentCount(
        courseId: courseId,
      );

      return Right(courses);
    } on FirebaseException catch (error) {
      return Left(ServerFailure(error.message ?? 'Failed to load courses'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<Session>>> watchCourseSessions({
    required String courseId,
  }) async* {
    try {
      await for (final courses in lecturerRemoteDataSource.watchCourseSessions(
        courseId: courseId,
      )) {
        yield right(courses);
      }
    } on FirebaseException catch (error) {
      yield Left(ServerFailure(error.message ?? 'Failed to load courses'));
    } catch (error) {
      yield Left(ServerFailure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, int>> watchSessionAttendanceCount({
    required String sessionId,
  }) async* {
    try {
      await for (final courses
          in lecturerRemoteDataSource.watchSessionAttendanceCount(
            sessionId: sessionId,
          )) {
        yield right(courses);
      }
    } on FirebaseException catch (error) {
      yield Left(
        ServerFailure(error.message ?? 'Failed to load session attendance'),
      );
    } catch (error) {
      yield Left(ServerFailure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, int>> watchCourseStudentCount({
    required String courseId,
  }) async* {
    try {
      await for (final studentCount
          in lecturerRemoteDataSource.watchCourseStudentCount(
            courseId: courseId,
          )) {
        yield right(studentCount);
      }
    } on FirebaseException catch (error) {
      yield Left(
        ServerFailure(error.message ?? 'Failed to load course student count'),
      );
    } catch (error) {
      yield Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addCourse({
    required String lecturerId,
    required String code,
    required String name,
    required String level,
  }) async {
    try {
      final courses = await lecturerRemoteDataSource.addCourse(
        lecturerId: lecturerId,
        code: code,
        name: name,
        level: level,
      );

      return Right(courses);
    } on FirebaseException catch (error) {
      return Left(ServerFailure(error.message ?? 'Failed to load courses'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
