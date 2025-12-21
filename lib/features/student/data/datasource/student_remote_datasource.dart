import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';

abstract interface class StudentRemoteDatasource {
  // Search
  Stream<List<CourseSearchItem>> watchCourses({String? search});
  Future<void> enrollInCourse({
    required CourseSearchItem course,
    required String studentId,
  });

  Future<bool> isStudentEnrolled({
    required String courseId,
    required String studentId,
  });

  // Student home
  Stream<List<String>> watchEnrolledCourseIds({required String studentId});

  Stream<List<Session>> watchTodaySessionsForStudent({
    required String studentId,
    required DateTime dayStart,
    required DateTime dayEnd,
  });

  // QR scan preview (no write yet)
  Future<ScanPreview> getScanPreview({required String qrPayload});

  // Confirm attendance (writes)
  Future<AttendanceRecord> confirmAttendance({
    required String studentId,
    required String qrPayload,
    DateTime? now,
  });

  Stream<List<StudentAttendanceItem>> watchAttendanceHistory({
    required String studentId,
    required DateTime from,
    required DateTime to,
    String? courseId,
  });

  // add this (for "All Courses" dropdown)
  Stream<List<EnrollmentCourseOption>> watchStudentCourseOptions({
    required String studentId,
  });

  /// Fast lookup of attendance by sessionId(s) using the student's mirror collection.
  Stream<Map<String, AttendanceStatus>> watchMyAttendanceForSessions({
    required String studentId,
    required List<String> sessionIds,
  });
}

class StudentRemoteDatasourceImpl implements StudentRemoteDatasource {
  final FirebaseFirestore firebaseFirestore;

  const StudentRemoteDatasourceImpl({required this.firebaseFirestore});

  CollectionReference<Map<String, dynamic>> get _users =>
      firebaseFirestore.collection('users');
  CollectionReference<Map<String, dynamic>> get _courses =>
      firebaseFirestore.collection('courses');
  CollectionReference<Map<String, dynamic>> get _sessions =>
      firebaseFirestore.collection('sessions');

  // ---------- helpers ----------

  AttendanceStatus _statusFromString(String v) =>
      v == 'late' ? AttendanceStatus.late : AttendanceStatus.present;

  String _statusToString(AttendanceStatus s) =>
      s == AttendanceStatus.late ? 'late' : 'present';

  ({String sessionId, String token}) _parseQr(String qrPayload) {
    // Expect JSON: {"sid":"...", "t":"..."}
    final decoded = jsonDecode(qrPayload);
    if (decoded is! Map<String, dynamic>) {
      throw StateError('Invalid QR payload format.');
    }
    final sid = decoded['sid'];
    final t = decoded['t'];
    if (sid is! String || sid.isEmpty || t is! String || t.isEmpty) {
      throw StateError('Invalid QR payload values.');
    }
    return (sessionId: sid, token: t);
  }

  String _monthKey(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    return '$y-$m';
  }

  Session _sessionFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Session(
      id: doc.id,
      courseId: (data['courseId'] as String?) ?? '',
      lecturerId: (data['lecturerId'] as String?) ?? '',
      dateTimeStart:
          (data['dateTimeStart'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dateTimeEnd: (data['dateTimeEnd'] as Timestamp?)?.toDate(),
      isOpen: (data['isOpen'] as bool?) ?? false,
      qrToken: (data['qrToken'] as String?) ?? '',
      attendanceCount: ((data['attendanceCount'] as num?) ?? 0).toInt(),
      topic: data['topic'] as String?,
      lateAfterMinutes: (data['lateAfterMinutes'] as num?)?.toInt(),
    );
  }

  CourseSearchItem _courseFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return CourseSearchItem(
      id: doc.id,
      code: (d['code'] as String?) ?? '',
      name: (d['name'] as String?) ?? '',
      lecturerId: (d['lecturerId'] as String?) ?? '',
      studentCount: ((d['studentCount'] as num?) ?? 0).toInt(),
    );
  }

  // ---------- Scan Preview (READ ONLY) ----------

  @override
  Future<ScanPreview> getScanPreview({required String qrPayload}) async {
    final qr = _parseQr(qrPayload);

    final sessionDoc = await _sessions.doc(qr.sessionId).get();
    if (!sessionDoc.exists) throw StateError('Session not found.');

    final s = sessionDoc.data()!;
    final isOpen = (s['isOpen'] as bool?) ?? false;
    final storedToken = (s['qrToken'] as String?) ?? '';
    if (storedToken.isEmpty) throw StateError('Session token missing.');
    if (storedToken != qr.token) throw StateError('Invalid QR token.');

    final courseId = (s['courseId'] as String?) ?? '';
    final lecturerId = (s['lecturerId'] as String?) ?? '';
    final startAt =
        (s['dateTimeStart'] as Timestamp?)?.toDate() ?? DateTime.now();
    final endAt = (s['dateTimeEnd'] as Timestamp?)?.toDate();

    if (courseId.isEmpty) throw StateError('Session missing courseId.');
    if (lecturerId.isEmpty) throw StateError('Session missing lecturerId.');

    // Fetch course info (code + name)
    final courseDoc = await _courses.doc(courseId).get();
    if (!courseDoc.exists) throw StateError('Course not found.');

    final c = courseDoc.data()!;
    final code = (c['code'] as String?) ?? '';
    final name = (c['name'] as String?) ?? '';
    final courseTitle = code.isNotEmpty ? '$code: $name' : name;

    // Fetch lecturer name
    final lecturerDoc = await _users.doc(lecturerId).get();
    final lecturerName = (lecturerDoc.data()?['name'] as String?) ?? 'Lecturer';

    return ScanPreview(
      sessionId: qr.sessionId,
      courseId: courseId,
      courseTitle: courseTitle,
      lecturerName: lecturerName,
      startAt: startAt,
      endAt: endAt,
      isOpen: isOpen,
    );
  }

  // ---------- Confirm Attendance (WRITE: transaction) ----------

  @override
  Future<AttendanceRecord> confirmAttendance({
    required String studentId,
    required String qrPayload,
    DateTime? now,
  }) async {
    final qr = _parseQr(qrPayload);

    final nowDt = now ?? DateTime.now();
    final nowTs = Timestamp.fromDate(nowDt);

    final sessionRef = _sessions.doc(qr.sessionId);
    final attendanceRef = sessionRef
        .collection('attendance')
        .doc(studentId); // deterministic
    final studentHistoryRef = _users
        .doc(studentId)
        .collection('attendance')
        .doc(qr.sessionId);

    // Transaction ensures:
    // - attendance is written once
    // - attendanceCount increments once
    // - history mirror written consistently

    return firebaseFirestore.runTransaction((tx) async {
      final sessionSnap = await tx.get(sessionRef);
      if (!sessionSnap.exists) throw StateError('Session not found.');

      final s = sessionSnap.data()!;
      final isOpen = (s['isOpen'] as bool?) ?? false;
      final storedToken = (s['qrToken'] as String?) ?? '';
      final courseId = (s['courseId'] as String?) ?? '';
      final lecturerId = (s['lecturerId'] as String?) ?? '';
      final lateAfterMinutes = ((s['lateAfterMinutes'] as num?) ?? 10).toInt();
      final startAt = (s['dateTimeStart'] as Timestamp?)?.toDate() ?? nowDt;

      if (!isOpen) throw StateError('Session is closed.');
      if (storedToken != qr.token) throw StateError('Invalid QR token.');
      if (courseId.isEmpty) throw StateError('Session missing courseId.');
      if (lecturerId.isEmpty) throw StateError('Session missing lecturerId.');

      // Enrollment check (lightweight):
      // require users/{studentId}/enrollments/{courseId} to exist
      final enrollmentRef = _users
          .doc(studentId)
          .collection('enrollments')
          .doc(courseId);
      final enrollmentSnap = await tx.get(enrollmentRef);
      if (!enrollmentSnap.exists) {
        throw StateError('You are not enrolled in this course.');
      }

      // Determine present/late
      final diffMin = nowDt.difference(startAt).inMinutes;
      final status = diffMin > lateAfterMinutes
          ? AttendanceStatus.late
          : AttendanceStatus.present;

      // Ensure not already marked
      final existing = await tx.get(attendanceRef);
      if (existing.exists) {
        // Already marked – return existing status (or just treat as success).
        final existingData = existing.data();
        final existingStatus = _statusFromString(
          (existingData?['status'] as String?) ?? 'present',
        );
        final existingTs =
            (existingData?['timestamp'] as Timestamp?)?.toDate() ?? nowDt;

        return AttendanceRecord(
          sessionId: qr.sessionId,
          courseId: courseId,
          studentId: studentId,
          timestamp: existingTs,
          status: existingStatus,
        );
      }

      // Fetch course code/name for history mirror (READ inside tx)
      final courseRef = _courses.doc(courseId);
      final courseSnap = await tx.get(courseRef);
      if (!courseSnap.exists) throw StateError('Course not found.');
      final c = courseSnap.data()!;
      final courseCode = (c['code'] as String?) ?? '';
      final courseName = (c['name'] as String?) ?? '';
      final courseTitle = courseCode.isNotEmpty
          ? '$courseCode: $courseName'
          : courseName;

      // Optional lecturer name for history (READ inside tx)
      final lecturerRef = _users.doc(lecturerId);
      final lecturerSnap = await tx.get(lecturerRef);
      final lecturerName =
          (lecturerSnap.data()?['name'] as String?) ?? 'Lecturer';

      // 1) write attendance under session
      tx.set(attendanceRef, {
        'studentId': studentId,
        'courseId': courseId,
        'timestamp': nowTs,
        'status': _statusToString(status),
      });

      // 2) increment session attendanceCount
      tx.update(sessionRef, {'attendanceCount': FieldValue.increment(1)});

      // 3) write student history mirror (for history screen)
      tx.set(studentHistoryRef, {
        'sessionId': qr.sessionId,
        'courseId': courseId,
        'courseCode': courseCode,
        'courseName': courseName,
        'courseTitle': courseTitle,
        'lecturerId': lecturerId,
        'lecturerName': lecturerName,
        'sessionStart': Timestamp.fromDate(startAt),
        'timestamp': nowTs,
        'status': _statusToString(status),
        'monthKey': _monthKey(nowDt),
      });

      return AttendanceRecord(
        sessionId: qr.sessionId,
        courseId: courseId,
        studentId: studentId,
        timestamp: nowDt,
        status: status,
      );
    });
  }

  // ---------- History (stream) ----------

  @override
  Stream<List<StudentAttendanceItem>> watchAttendanceHistory({
    required String studentId,
    required DateTime from,
    required DateTime to,
    String? courseId,
  }) {
    Query<Map<String, dynamic>> q = _users
        .doc(studentId)
        .collection('attendance');

    q = q.where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    q = q.where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(to));

    if (courseId != null && courseId.isNotEmpty) {
      q = q.where('courseId', isEqualTo: courseId);
    }

    q = q.orderBy('timestamp', descending: true);

    return q.snapshots().map((snap) {
      return snap.docs.map((d) {
        final data = d.data();
        final status = _statusFromString(
          (data['status'] as String?) ?? 'present',
        );
        final ts =
            (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
        final sessionStart =
            (data['sessionStart'] as Timestamp?)?.toDate() ?? ts;

        final courseTitle =
            (data['courseTitle'] as String?) ?? _fallbackCourseTitle(data);

        return StudentAttendanceItem(
          sessionId: (data['sessionId'] as String?) ?? d.id,
          courseId: (data['courseId'] as String?) ?? '',
          courseTitle: courseTitle,
          timestamp: ts,
          status: status,
          sessionStart: sessionStart,
        );
      }).toList();
    });
  }

  String _fallbackCourseTitle(Map<String, dynamic> data) {
    final code = (data['courseCode'] as String?) ?? '';
    final name = (data['courseName'] as String?) ?? '';
    if (code.isEmpty) return name;
    if (name.isEmpty) return code;
    return '$code: $name';
  }

  @override
  Future<void> enrollInCourse({
    required CourseSearchItem course,
    required String studentId,
  }) async {
    final courseRef = firebaseFirestore.collection('courses').doc(course.id);
    final courseStudentRef = courseRef.collection('students').doc(studentId);

    final userEnrollRef = _users
        .doc(studentId)
        .collection('enrollments')
        .doc(course.id);

    await firebaseFirestore.runTransaction((tx) async {
      // Prevent double enroll using user enrollment doc
      final existing = await tx.get(userEnrollRef);
      if (existing.exists) return;

      // Create course roster doc (lecturer list)
      tx.set(courseStudentRef, {
        'studentId': studentId,
        'addedAt': FieldValue.serverTimestamp(),
      });

      // Create student enrollment doc (fast access)
      tx.set(userEnrollRef, {
        'courseId': course.id,
        'courseCode': course.code,
        'courseName': course.name,
        'courseTitle': course.title,
        'lecturerId': course.lecturerId,
        'enrolledAt': FieldValue.serverTimestamp(),
      });

      // Increment course studentCount
      tx.update(courseRef, {'studentCount': FieldValue.increment(1)});
    });
  }

  @override
  Future<bool> isStudentEnrolled({
    required String courseId,
    required String studentId,
  }) async {
    final doc = await _users
        .doc(studentId)
        .collection('enrollments')
        .doc(courseId)
        .get();
    return doc.exists;
  }

  @override
  Stream<List<String>> watchEnrolledCourseIds({required String studentId}) {
    // TODO: implement watchEnrolledCourseIds
    throw UnimplementedError();
  }

  @override
  Stream<List<Session>> watchTodaySessionsForStudent({
    required String studentId,
    required DateTime dayStart,
    required DateTime dayEnd,
  }) {
    final enrollmentsRef = firebaseFirestore
        .collection('users')
        .doc(studentId)
        .collection('enrollments');

    return enrollmentsRef.snapshots().asyncMap((enrollSnap) async {
      final courseIds = enrollSnap.docs.map((d) => d.id).toList();
      if (courseIds.isEmpty) return <Session>[];

      final startTs = Timestamp.fromDate(dayStart);
      final endTs = Timestamp.fromDate(dayEnd);

      // Firestore whereIn max 10
      final chunks = <List<String>>[];
      for (var i = 0; i < courseIds.length; i += 10) {
        chunks.add(courseIds.sublist(i, (i + 10).clamp(0, courseIds.length)));
      }

      final futures = chunks.map((chunk) {
        return firebaseFirestore
            .collection('sessions')
            .where('courseId', whereIn: chunk)
            .where('dateTimeStart', isGreaterThanOrEqualTo: startTs)
            .where('dateTimeStart', isLessThanOrEqualTo: endTs)
            .orderBy('dateTimeStart')
            .get();
      });

      final snaps = await Future.wait(futures);
      final docs = snaps.expand((s) => s.docs).toList();

      final sessions = docs.map(_sessionFromDoc).toList()
        ..sort((a, b) => a.dateTimeStart.compareTo(b.dateTimeStart));

      return sessions;
    });
  }

  @override
  Stream<List<EnrollmentCourseOption>> watchStudentCourseOptions({
    required String studentId,
  }) {
    return firebaseFirestore
        .collection('users')
        .doc(studentId)
        .collection('enrollments')
        .orderBy('enrolledAt', descending: true)
        .snapshots()
        .map((snap) {
          return snap.docs.map((d) {
            final data = d.data();
            final title =
                (data['courseTitle'] as String?) ??
                _fallbackTitle(data); // code+name
            return EnrollmentCourseOption(courseId: d.id, courseTitle: title);
          }).toList();
        });
  }

  String _fallbackTitle(Map<String, dynamic> data) {
    final code = (data['courseCode'] as String?) ?? '';
    final name = (data['courseName'] as String?) ?? '';
    if (code.isEmpty) return name;
    if (name.isEmpty) return code;
    return '$code: $name';
  }

  @override
  Stream<Map<String, AttendanceStatus>> watchMyAttendanceForSessions({
    required String studentId,
    required List<String> sessionIds,
  }) {
    if (sessionIds.isEmpty) {
      return Stream.value(<String, AttendanceStatus>{});
    }

    final attendanceRef = firebaseFirestore
        .collection('users')
        .doc(studentId)
        .collection('attendance');

    return attendanceRef.snapshots().map((snap) {
      final map = <String, AttendanceStatus>{};
      for (final doc in snap.docs) {
        if (!sessionIds.contains(doc.id)) continue;
        final data = doc.data();
        final s = (data['status'] as String?) ?? 'present';
        map[doc.id] = s == 'late'
            ? AttendanceStatus.late
            : AttendanceStatus.present;
      }
      return map;
    });
  }

  @override
  Stream<List<CourseSearchItem>> watchCourses({String? search}) {
    Query<Map<String, dynamic>> q = firebaseFirestore
        .collection('courses')
        .orderBy('createdAt', descending: true);

    // Lightweight search approach:
    // Firestore doesn't do contains search; we do:
    // - if search is empty: show latest courses
    // - else: orderBy code and name is not possible simultaneously without extra fields
    // Recommended minimal: use "code" exact-ish search + client-side filter for name.
    //
    // If you want true search later, add fields:
    // - searchKeywords: array<string>
    // or integrate Algolia/Meilisearch.
    //
    // For now: fetch latest 50 and filter locally.
    q = q.limit(50);

    return q.snapshots().map((snap) {
      var list = snap.docs.map(_courseFromDoc).toList();
      final term = (search ?? '').trim().toLowerCase();
      if (term.isNotEmpty) {
        list = list.where((c) {
          return c.code.toLowerCase().contains(term) ||
              c.name.toLowerCase().contains(term);
        }).toList();
      }
      return list;
    });
  }
}
