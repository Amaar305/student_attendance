import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/lecturer/domain/entities/course_student.dart';
import 'package:student_attendance/features/lecturer/domain/entities/session_student_attendance.dart';

abstract interface class LecturerRemoteDataSource {
  Stream<List<Course>> watchLecturerCourses({required String lecturerId});

  Stream<List<CourseStudent>> watchLecturerStudents({
    required String lecturerId,
  });

  Stream<int> watchSessionAttendanceCount({required String sessionId});

  Stream<List<Session>> watchCourseSessions({required String courseId});

  Future<int> getCourseStudentCount({required String courseId});

  Stream<int> watchCourseStudentCount({required String courseId}); // preferred

  Future<List<SessionStudentAttendance>> getSessionStudentAttendance({
    required String courseId,
    required String sessionId,
  });

  Future<void> addCourse({
    required String lecturerId,
    required String code,
    required String name,
    required String level,
  });
}

class LecturerRemoteDataSourceImpl implements LecturerRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  LecturerRemoteDataSourceImpl({required this.firebaseFirestore});

  CollectionReference<Map<String, dynamic>> get _courses =>
      firebaseFirestore.collection('courses');
  CollectionReference<Map<String, dynamic>> get _sessions =>
      firebaseFirestore.collection('sessions');
  CollectionReference<Map<String, dynamic>> get _users =>
      firebaseFirestore.collection('users');

  final Map<String, AppUser> _userCache = {};

  // ---------- Helpers ----------

  Course _courseFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Course(
      id: doc.id,
      code: (d['code'] as String?) ?? '',
      name: (d['name'] as String?) ?? '',
      level: (d['level'] as String?) ?? '',
      lecturerId: (d['lecturerId'] as String?) ?? '',
      studentCount: ((d['studentCount'] as num?) ?? 0).toInt(),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Session _sessionFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Session(
      id: doc.id,
      courseId: (d['courseId'] as String?) ?? '',
      lecturerId: (d['lecturerId'] as String?) ?? '',
      dateTimeStart:
          (d['dateTimeStart'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dateTimeEnd: (d['dateTimeEnd'] as Timestamp?)?.toDate(),
      isOpen: (d['isOpen'] as bool?) ?? false,
      qrToken: (d['qrToken'] as String?) ?? '',
      attendanceCount: ((d['attendanceCount'] as num?) ?? 0).toInt(),
      topic: d['topic'] as String?,
      lateAfterMinutes: (d['lateAfterMinutes'] as num?)?.toInt(),
    );
  }

  @override
  Stream<List<Course>> watchLecturerCourses({required String lecturerId}) {
    return _courses
        .where('lecturerId', isEqualTo: lecturerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(_courseFromDoc).toList());
  }

  @override
  Stream<List<CourseStudent>> watchLecturerStudents({
    required String lecturerId,
  }) {
    late final StreamController<List<CourseStudent>> controller;
    StreamSubscription? coursesSub;
    final rosterSubs =
        <String, StreamSubscription<List<CourseStudent>>>{};
    final studentsByCourse = <String, List<CourseStudent>>{};
    final coursesById = <String, Course>{};

    void emitCombined() {
      if (controller.isClosed) return;
      final combined = <CourseStudent>[];
      studentsByCourse.forEach((courseId, students) {
        final title = coursesById[courseId]?.title ?? '';
        for (final item in students) {
          combined.add(
            title.isEmpty || item.courseTitle == title
                ? item
                : CourseStudent(
                    courseId: item.courseId,
                    courseTitle: title,
                    student: item.student,
                  ),
          );
        }
      });
      combined.sort(_compareCourseStudents);
      controller.add(combined);
    }

    void unsubscribeCourse(String courseId) {
      rosterSubs.remove(courseId)?.cancel();
      studentsByCourse.remove(courseId);
      coursesById.remove(courseId);
    }

    void subscribeCourse(Course course) {
      if (rosterSubs.containsKey(course.id)) return;

      final stream = _courses
          .doc(course.id)
          .collection('students')
          .snapshots()
          .asyncMap((snap) async {
            final studentIds = snap.docs
                .map((doc) {
                  final data = doc.data();
                  return (data['studentId'] as String?) ?? doc.id;
                })
                .where((id) => id.isNotEmpty)
                .toList();

            if (studentIds.isEmpty) return <CourseStudent>[];

            final usersById = await _fetchUsersByIds(studentIds);
            final courseTitle = course.title;

            final items = studentIds.map((studentId) {
              final user = usersById[studentId] ?? AppUser(id: studentId);
              return CourseStudent(
                courseId: course.id,
                courseTitle: courseTitle,
                student: user,
              );
            }).toList()
              ..sort(_compareCourseStudents);

            return items;
          });

      rosterSubs[course.id] = stream.listen(
        (items) {
          studentsByCourse[course.id] = items;
          emitCombined();
        },
        onError: controller.addError,
      );
    }

    controller = StreamController<List<CourseStudent>>(
      onListen: () {
        coursesSub = _courses
            .where('lecturerId', isEqualTo: lecturerId)
            .orderBy('createdAt', descending: true)
            .snapshots()
            .listen(
              (snap) {
                final courses = snap.docs.map(_courseFromDoc).toList();
                final ids = courses.map((c) => c.id).toSet();
                for (final id in rosterSubs.keys.toList()) {
                  if (!ids.contains(id)) {
                    unsubscribeCourse(id);
                  }
                }
                for (final course in courses) {
                  coursesById[course.id] = course;
                  subscribeCourse(course);
                }
                emitCombined();
              },
              onError: controller.addError,
            );
      },
      onCancel: () async {
        await coursesSub?.cancel();
        for (final sub in rosterSubs.values) {
          await sub.cancel();
        }
        rosterSubs.clear();
        studentsByCourse.clear();
      },
    );

    return controller.stream;
  }

  @override
  Future<int> getCourseStudentCount({required String courseId}) async {
    final doc = await _courses.doc(courseId).get();
    final data = doc.data();
    return ((data?['studentCount'] as num?) ?? 0).toInt();
  }

  @override
  Stream<List<Session>> watchCourseSessions({required String courseId}) {
    return _sessions
        .where('courseId', isEqualTo: courseId)
        .orderBy('dateTimeStart', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(_sessionFromDoc).toList());
  }

  @override
  Stream<int> watchSessionAttendanceCount({required String sessionId}) {
    return _sessions.doc(sessionId).snapshots().map((doc) {
      final d = doc.data();
      return ((d?['attendanceCount'] as num?) ?? 0).toInt();
    });
  }

  @override
  Stream<int> watchCourseStudentCount({required String courseId}) {
    return firebaseFirestore
        .collection('courses')
        .doc(courseId)
        .snapshots()
        .map((doc) {
          final data = doc.data();
          return ((data?['studentCount'] as num?) ?? 0).toInt();
        });
  }

  @override
  Future<void> addCourse({
    required String lecturerId,
    required String code,
    required String name,
    required String level,
  }) async {
    await _courses.add({
      'lecturerId': lecturerId,
      'code': code,
      'name': name,
      'level': level,
      'studentCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<SessionStudentAttendance>> getSessionStudentAttendance({
    required String courseId,
    required String sessionId,
  }) async {
    final rosterSnap =
        await _courses.doc(courseId).collection('students').get();
    final studentIds = rosterSnap.docs
        .map((doc) => (doc.data()['studentId'] as String?) ?? doc.id)
        .where((id) => id.isNotEmpty)
        .toList();

    if (studentIds.isEmpty) return [];

    final attendanceSnap =
        await _sessions.doc(sessionId).collection('attendance').get();
    final attendanceByStudent = <String, _AttendanceEntry>{};
    for (final doc in attendanceSnap.docs) {
      final data = doc.data();
      final studentId = (data['studentId'] as String?) ?? doc.id;
      if (studentId.isEmpty) continue;
      attendanceByStudent[studentId] = _AttendanceEntry(
        status: _statusFromString(data['status'] as String?),
        timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
      );
    }

    final usersById = await _fetchUsersByIds(studentIds);

    final items = studentIds.map((studentId) {
      final user = usersById[studentId] ?? AppUser(id: studentId);
      final attendance = attendanceByStudent[studentId];
      return SessionStudentAttendance(
        student: user,
        status: attendance?.status,
        checkedInAt: attendance?.timestamp,
      );
    }).toList()
      ..sort(_compareStudents);

    return items;
  }

  AttendanceStatus _statusFromString(String? value) =>
      value == 'late' ? AttendanceStatus.late : AttendanceStatus.present;

  Future<Map<String, AppUser>> _fetchUsersByIds(List<String> ids) async {
    final missing = ids.where((id) => !_userCache.containsKey(id)).toList();
    if (missing.isNotEmpty) {
      final chunks = <List<String>>[];
      for (var i = 0; i < missing.length; i += 10) {
        chunks.add(missing.sublist(i, (i + 10).clamp(0, missing.length)));
      }

      final futures = chunks.map((chunk) {
        return _users.where(FieldPath.documentId, whereIn: chunk).get();
      });
      final snaps = await Future.wait(futures);
      final docs = snaps.expand((s) => s.docs);

      for (final doc in docs) {
        final data = doc.data();
        _userCache[doc.id] = AppUser.fromJson({...data, 'id': doc.id});
      }
    }

    final map = <String, AppUser>{};
    for (final id in ids) {
      final user = _userCache[id];
      if (user != null) map[id] = user;
    }
    return map;
  }

  int _compareStudents(SessionStudentAttendance a, SessionStudentAttendance b) {
    final nameA = (a.student.name ?? '').toLowerCase();
    final nameB = (b.student.name ?? '').toLowerCase();
    if (nameA != nameB) return nameA.compareTo(nameB);

    final numA = (a.student.studentNumber ?? '').toLowerCase();
    final numB = (b.student.studentNumber ?? '').toLowerCase();
    if (numA != numB) return numA.compareTo(numB);

    return a.student.id.compareTo(b.student.id);
  }

  int _compareCourseStudents(CourseStudent a, CourseStudent b) {
    final nameA = (a.student.name ?? '').toLowerCase();
    final nameB = (b.student.name ?? '').toLowerCase();
    if (nameA != nameB) return nameA.compareTo(nameB);

    final numA = (a.student.studentNumber ?? '').toLowerCase();
    final numB = (b.student.studentNumber ?? '').toLowerCase();
    if (numA != numB) return numA.compareTo(numB);

    return a.student.id.compareTo(b.student.id);
  }
}

class _AttendanceEntry {
  const _AttendanceEntry({required this.status, required this.timestamp});

  final AttendanceStatus status;
  final DateTime? timestamp;
}
