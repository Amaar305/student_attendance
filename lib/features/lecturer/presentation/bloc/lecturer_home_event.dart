part of 'lecturer_home_bloc.dart';

abstract class LecturerHomeEvent extends Equatable {
  const LecturerHomeEvent();

  @override
  List<Object> get props => [];
}

class LecturerCoursesSubscriptionRequested extends LecturerHomeEvent {
  
}
