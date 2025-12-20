class ScanPreview {
  const ScanPreview({
    required this.sessionId,
    required this.courseId,
    required this.courseTitle, // "CS101: Intro to Programming"
    required this.lecturerName,
    required this.startAt,
    required this.endAt,
    required this.isOpen,
  });

  final String sessionId;
  final String courseId;
  final String courseTitle;
  final String lecturerName;
  final DateTime startAt;
  final DateTime? endAt;
  final bool isOpen;
}
