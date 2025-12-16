import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/features/home/presentation/presentation.dart';

class HomeLecturerView extends StatelessWidget {
  const HomeLecturerView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: AppConstrainedScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xlg,
          children: [
            // Appbar
            HomeLecturerAppBar(),

            // Lecturer Quick Actions
            HomeLecturerQuickActions(),

            // Lecturer's courses
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.lg,
              children: [
                Text(
                  'My Courses',
                  style: context.titleMedium?.copyWith(
                    fontWeight: AppFontWeight.semiBold,
                    color: AppColors.primaryDarkBlue,
                  ),
                ),

                HomeCourseTile(
                  title: 'CSC101 - Intro to Programming',
                  studentCount: 120,
                ),

                HomeCourseTile(
                  title: 'CSC101 - Intro to Programming',
                  studentCount: 120,
                ),
                HomeCourseTile(
                  title: 'CSC101 - Intro to Programming',
                  studentCount: 120,
                ),

                HomeCourseTile(
                  title: 'CSC101 - Intro to Programming',
                  studentCount: 120,
                ),
                HomeCourseTile(
                  title: 'CSC101 - Intro to Programming',
                  studentCount: 120,
                ),

                HomeCourseTile(
                  title: 'CSC101 - Intro to Programming',
                  studentCount: 120,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
