// ignore_for_file: public_member_api_docs

class Course {
  const Course({
    required this.id,
    required this.code,
    required this.name,
    required this.lecturerId,
    required this.studentCount,
    required this.level,
    required this.createdAt,
  });

  final String id;
  final String code;
  final String name;
  final String lecturerId;
  final String level;
  final int studentCount;
  final DateTime createdAt;
}
