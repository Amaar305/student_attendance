// ignore_for_file: public_member_api_docs

class CourseSearchItem {
  const CourseSearchItem({
    required this.id,
    required this.code,
    required this.name,
    required this.lecturerId,
    required this.studentCount,
  });

  final String id;
  final String code;
  final String name;
  final String lecturerId;
  final int studentCount;

  String get title => code.isNotEmpty ? '$code: $name' : name;
}
