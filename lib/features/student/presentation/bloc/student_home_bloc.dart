import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'student_home_event.dart';
part 'student_home_state.dart';

class StudentHomeBloc extends Bloc<StudentHomeEvent, StudentHomeState> {
  StudentHomeBloc() : super(StudentHomeInitial());
}
