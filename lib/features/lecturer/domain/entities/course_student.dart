import 'package:shared/shared.dart';

class CourseStudent {
  const CourseStudent({
    required this.courseId,
    required this.courseTitle,
    required this.student,
  });

  final String courseId;
  final String courseTitle;
  final AppUser student;
}
