import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/app/cubit/app_cubit.dart';
import 'package:student_attendance/features/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppCubit element) => element.state.user);

    if (user == null) return SizedBox.shrink();

    final child = switch (user.role) {
      UserRole.student => HomeStudentView(),
      UserRole.lecturer => HomeLecturerView(),
      _ => SizedBox.expand(),
    };
    return child;
  }
}
