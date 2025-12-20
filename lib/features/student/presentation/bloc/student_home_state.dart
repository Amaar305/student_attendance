part of 'student_home_bloc.dart';

abstract class StudentHomeState extends Equatable {
  const StudentHomeState();
  
  @override
  List<Object> get props => [];
}

class StudentHomeInitial extends StudentHomeState {}
