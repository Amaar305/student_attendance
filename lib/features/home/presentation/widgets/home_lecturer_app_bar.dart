import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/app/cubit/app_cubit.dart';

class HomeLecturerAppBar extends StatelessWidget {
  const HomeLecturerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = context.select(
      (AppCubit element) => element.state.user?.name ?? '',
    );
    final name = userName.split(' ').take(2).join(' ');
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: AppColors.blue,
        child: Text(
          name.isNotEmpty ? name[0] : '?',
          style: textTheme.headlineSmall?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(
        'Dr. $name',
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      subtitle: Text(
        'Senior Lecturer',
        style: textTheme.titleSmall?.copyWith(
          color: AppColors.emphasizeGrey,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
