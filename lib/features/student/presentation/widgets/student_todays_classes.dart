import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_attendance/app/routes/app_routes.dart';
import 'package:student_attendance/features/student/student.dart';

class StudentTodaysClasses extends StatelessWidget {
  const StudentTodaysClasses({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Classes',
          style: context.titleMedium?.copyWith(
            fontWeight: AppFontWeight.semiBold,
            color: AppColors.primaryDarkBlue,
          ),
        ),

        TodayClasses(),
      ],
    );
  }
}

class TodayClasses extends StatelessWidget {
  const TodayClasses({super.key});

  @override
  Widget build(BuildContext context) {
    final todayItems = context.select(
      (StudentHomeCubit element) => element.state.todayItems,
    );
    final isLoading = context.select(
      (StudentHomeCubit element) => element.state.loading,
    );

    if (isLoading && todayItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 30),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (todayItems.isEmpty) {
      return StudentEmptyToday(
        onScan: () => context.push(AppRoutes.scanAttendance),
      );
    } else {
      return Column(
        children: List.generate(todayItems.length, (index) {
          return StudentTodayClassTile(item: todayItems[index]);
        }),
      );
    }
  }
}
