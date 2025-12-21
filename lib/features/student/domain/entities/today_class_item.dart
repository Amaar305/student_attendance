import 'package:equatable/equatable.dart';

enum ClassStatus { upcoming, ongoing, present, late }

class TodayClassItem extends Equatable {
  const TodayClassItem({
    required this.sessionId,
    required this.courseId,
    required this.title,
    required this.startAt,
    required this.endAt,
    required this.isOpen,
    required this.status,
  });

  final String sessionId;
  final String courseId;
  final String title; // e.g. "CSC 101: Intro to CS"
  final DateTime startAt;
  final DateTime? endAt;
  final bool isOpen;
  final ClassStatus status;

  @override
  List<Object?> get props => [
    sessionId,
    courseId,
    title,
    startAt,
    endAt,
    isOpen,
    status,
  ];
}
