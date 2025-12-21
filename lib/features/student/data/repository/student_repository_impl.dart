import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDatasource studentRemoteDatasource;

  const StudentRepositoryImpl({required this.studentRemoteDatasource});

  @override
  Future<Either<Failure, void>> enrollInCourse({
    required CourseSearchItem course,
    required String studentId,
  }) async {
    try {
      await studentRemoteDatasource.enrollInCourse(
        studentId: studentId,
        course: course,
      );

      return right(null);
    } on FirebaseException catch (error) {
      return Left(ServerFailure(error.message ?? 'Failed to enroll in course'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isStudentEnrolled({
    required String courseId,
    required String studentId,
  }) async {
    try {
      final isEnrolled = await studentRemoteDatasource.isStudentEnrolled(
        courseId: courseId,
        studentId: studentId,
      );

      return Right(isEnrolled);
    } on FirebaseException catch (error) {
      return Left(ServerFailure(error.message ?? 'Failed to check enrollment'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<String>>> watchEnrolledCourseIds({
    required String studentId,
  }) async* {
    try {
      await for (final courseIds
          in studentRemoteDatasource.watchEnrolledCourseIds(
            studentId: studentId,
          )) {
        yield right(courseIds);
      }
    } on FirebaseException catch (error) {
      yield Left(
        ServerFailure(error.message ?? 'Failed to load enrolled courses'),
      );
    } catch (error) {
      yield Left(ServerFailure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<Session>>> watchTodaySessionsForStudent({
    required String studentId,
    required DateTime dayStart,
    required DateTime dayEnd,
  }) async* {
    try {
      await for (final sessions
          in studentRemoteDatasource.watchTodaySessionsForStudent(
            studentId: studentId,
            dayStart: dayStart,
            dayEnd: dayEnd,
          )) {
        yield right(sessions);
      }
    } on FirebaseException catch (error) {
      yield Left(ServerFailure(error.message ?? 'Failed to load sessions'));
    } catch (error) {
      yield Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, ScanPreview>> getScanPreview({
    required String qrPayload,
  }) async {
    try {
      final scanPreview = await studentRemoteDatasource.getScanPreview(
        qrPayload: qrPayload,
      );

      return Right(scanPreview);
    } on FirebaseException catch (error) {
      return Left(
        ServerFailure(error.message ?? 'Failed to load scan preview'),
      );
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, AttendanceRecord>> confirmAttendance({
    required String studentId,
    required String qrPayload,
    DateTime? now,
  }) async {
    try {
      final attendance = await studentRemoteDatasource.confirmAttendance(
        studentId: studentId,
        qrPayload: qrPayload,
        now: now,
      );

      return Right(attendance);
    } on FirebaseException catch (error) {
      return Left(
        ServerFailure(error.message ?? 'Failed to confirm attendance'),
      );
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<StudentAttendanceItem>>> watchAttendanceHistory({
    required String studentId,
    required DateTime from,
    required DateTime to,
    String? courseId,
  }) async* {
    try {
      await for (final history
          in studentRemoteDatasource.watchAttendanceHistory(
            studentId: studentId,
            from: from,
            to: to,
            courseId: courseId,
          )) {
        yield right(history);
      }
    } on FirebaseException catch (error) {
      yield Left(
        ServerFailure(error.message ?? 'Failed to load attendance history'),
      );
    } catch (error) {
      yield Left(ServerFailure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<EnrollmentCourseOption>>>
  watchStudentCourseOptions({required String studentId}) async* {
    try {
      await for (final courses
          in studentRemoteDatasource.watchStudentCourseOptions(
            studentId: studentId,
          )) {
        yield right(courses);
      }
    } on FirebaseException catch (error) {
      yield Left(
        ServerFailure(error.message ?? 'Failed to load course options'),
      );
    } catch (error) {
      yield Left(ServerFailure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, Map<String, AttendanceStatus>>>
  watchMyAttendanceForSessions({
    required String studentId,
    required List<String> sessionIds,
  }) async* {
    try {
      await for (final attendance
          in studentRemoteDatasource.watchMyAttendanceForSessions(
            studentId: studentId,
            sessionIds: sessionIds,
          )) {
        yield right(attendance);
      }
    } on FirebaseException catch (error) {
      yield Left(ServerFailure(error.message ?? 'Failed to load attendance'));
    } catch (error) {
      yield Left(ServerFailure(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<CourseSearchItem>>> watchCourses({
    String? search,
  }) async* {
    try {
      await for (final courses in studentRemoteDatasource.watchCourses(
        search: search,
      )) {
        yield right(courses);
      }
    } on FirebaseException catch (error) {
      yield Left(ServerFailure(error.message ?? 'Failed to load courses'));
    } catch (error) {
      yield Left(ServerFailure(error.toString()));
    }
  }
}
