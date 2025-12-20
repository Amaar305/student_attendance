import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/shared.dart';

abstract interface class LecturerRemoteDataSource {
  Stream<List<Course>> watchLecturerCourses({required String lecturerId});

  Stream<int> watchSessionAttendanceCount({required String sessionId});

  Stream<List<Session>> watchCourseSessions({required String courseId});

  Future<int> getCourseStudentCount({required String courseId});

  Stream<int> watchCourseStudentCount({required String courseId}); // preferred
}

class LecturerRemoteDataSourceImpl implements LecturerRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  const LecturerRemoteDataSourceImpl({required this.firebaseFirestore});

  CollectionReference<Map<String, dynamic>> get _courses =>
      firebaseFirestore.collection('courses');
  CollectionReference<Map<String, dynamic>> get _sessions =>
      firebaseFirestore.collection('sessions');

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
}
