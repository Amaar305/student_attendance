// ignore_for_file: public_member_api_docs

class Session {
  const Session({
    required this.id,
    required this.courseId,
    required this.lecturerId,
    required this.dateTimeStart,
    required this.isOpen,
    required this.qrToken,
    required this.attendanceCount,
    this.dateTimeEnd,
    this.topic,
    this.lateAfterMinutes,
  });

  final String id;
  final String courseId;
  final String lecturerId;
  final DateTime dateTimeStart;
  final DateTime? dateTimeEnd;
  final bool isOpen;
  final String qrToken;
  final int attendanceCount;

  final String? topic;
  final int? lateAfterMinutes;
}
