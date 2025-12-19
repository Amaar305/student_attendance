import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/shared.dart';

abstract interface class SessionRemoteDataSource {
  Future<Session> createOrGetOpenSession({
    required String courseId,
    required String lecturerId,
    required DateTime startAt,
    String? topic,
    required int lateAfterMinutes,
  });

  Future<void> closeSession({required String sessionId});

  Future<List<Course>> fetchLecturerCourses({required String lecturerId});

  /// QR payload string the lecturer will render as QR code.
  /// Keep it simple and safe (contains sessionId + token).
  String buildQrPayload({required String sessionId, required String qrToken});
}

class SessionDataSourceImpl implements SessionRemoteDataSource {
  final FirebaseFirestore firestore;
  const SessionDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _courses =>
      firestore.collection('courses');
  CollectionReference<Map<String, dynamic>> get _sessions =>
      firestore.collection('sessions');

  // ---------- Helpers ----------

  String _randomToken({int length = 12}) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // avoid ambiguous chars
    final rnd = Random.secure();
    return List.generate(
      length,
      (_) => chars[rnd.nextInt(chars.length)],
    ).join();
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
  String buildQrPayload({required String sessionId, required String qrToken}) {
    return jsonEncode({'sid': sessionId, 't': qrToken});
  }

  @override
  Future<void> closeSession({required String sessionId}) async {
    await _sessions.doc(sessionId).update({
      'isOpen': false,
      'dateTimeEnd': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<Session> createOrGetOpenSession({
    required String courseId,
    required String lecturerId,
    required DateTime startAt,
    String? topic,
    required int lateAfterMinutes,
  }) async {
    // 1) Check if open session exists (MVP-friendly).
    final openSnap = await _sessions
        .where('courseId', isEqualTo: courseId)
        .where('isOpen', isEqualTo: true)
        .limit(1)
        .get();

    if (openSnap.docs.isNotEmpty) {
      return _sessionFromDoc(openSnap.docs.first);
    }

    // 2) Create a new open session.
    final token = _randomToken();
    final ref = _sessions.doc();

    await ref.set({
      'courseId': courseId,
      'lecturerId': lecturerId,
      'dateTimeStart': Timestamp.fromDate(startAt),
      'dateTimeEnd': null,
      'isOpen': true,
      'qrToken': token,
      'attendanceCount': 0,
      'topic': topic,
      'lateAfterMinutes': lateAfterMinutes,
      'createdAt': FieldValue.serverTimestamp(),
    });

    final created = await ref.get();
    return _sessionFromDoc(created);
  }

  @override
  Future<List<Course>> fetchLecturerCourses({required String lecturerId}) {
    return _courses
        .where('lecturerId', isEqualTo: lecturerId)
        .orderBy('createdAt', descending: true)
        .get()
        .then(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return Course(
              id: doc.id,
              code: (data['code'] as String?) ?? '',
              name: (data['name'] as String?) ?? '',
              lecturerId: (data['lecturerId'] as String?) ?? '',
              studentCount: ((data['studentCount'] as num?) ?? 0).toInt(),
              level: (data['level'] as String?) ?? '',
              createdAt:
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            );
          }).toList(),
        );
  }
}
