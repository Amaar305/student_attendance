import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/app/cubit/app_cubit.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';
import 'package:student_attendance/features/student/student.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppCubit element) => element.state.user);

    if (user == null) return SizedBox.shrink();

    final child = switch (user.role) {
      UserRole.student => StudentHomePage(),
      UserRole.lecturer => LecturerHomePage(),
      _ => SizedBox.expand(),
    };
    return child;
  }
}
