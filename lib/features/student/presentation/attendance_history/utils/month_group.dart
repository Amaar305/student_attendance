import 'package:student_attendance/features/student/student.dart';

class MonthGroup {
  MonthGroup(this.title, this.items);
  final String title;
  final List<StudentAttendanceItem> items;
}

List<MonthGroup> groupByMonth(List<StudentAttendanceItem> items) {
  final map = <String, List<StudentAttendanceItem>>{};

  for (final item in items) {
    final d = item.timestamp;
    final key = '${d.year}-${d.month.toString().padLeft(2, '0')}';
    map.putIfAbsent(key, () => []).add(item);
  }

  final keys = map.keys.toList()
    ..sort((a, b) => b.compareTo(a)); // newest month first

  return keys.map((k) {
    final parts = k.split('-');
    final y = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    final title = '${_monthName(m).toUpperCase()} $y';
    final monthItems = map[k]!
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return MonthGroup(title, monthItems);
  }).toList();
}

String _monthName(int m) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return months[m - 1];
}
