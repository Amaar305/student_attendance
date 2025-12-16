///
String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

  String dayPrefix;
  if (dateToCheck == today) {
    dayPrefix = 'Today';
  } else if (dateToCheck == yesterday) {
    dayPrefix = 'Yesterday';
  } else {
    // For older dates, you could format as 'Jun 25, 2023' or similar
    // Here we'll just use the full date if it's not today or yesterday
    dayPrefix =
        '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
  }

  // Format time in 12-hour format with AM/PM
  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour < 12 ? 'am' : 'pm';
  final timeString = '$hour:$minute $period';

  return '$dayPrefix, $timeString';
}

String _getMonthName(int month) {
  const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return monthNames[month - 1];
}
