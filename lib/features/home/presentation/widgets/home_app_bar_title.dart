import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/app/cubit/app_cubit.dart';

class HomeAppBarTitle extends StatelessWidget {
  const HomeAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = context.select(
      (AppCubit element) => element.state.user?.name ?? '',
    );
    final firstName = userName.split(' ').first;
    return Text('Hello, $firstName');
  }
}
