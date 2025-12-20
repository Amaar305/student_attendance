part of 'course_view_bloc.dart';

abstract class CourseViewEvent extends Equatable {
  const CourseViewEvent();

  @override
  List<Object> get props => [];
}

class CourseViewToggleNewest extends CourseViewEvent {
  final int selectedIndex;

  const CourseViewToggleNewest({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}

class CourseSessionsSubscriptionRequested extends CourseViewEvent {}
