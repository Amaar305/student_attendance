import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/features/student/student.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StudentHomeView();
  }
}

class StudentHomeView extends StatelessWidget {
  const StudentHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: StudentAppBarTitle(),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: context.read<AppCubit>().signOut,
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: AppConstrainedScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xlg,
          children: [
            ScanQrcodeContainer(),
            StudentQuickAction(),
            StudentTodaysClasses(),
          ],
        ),
      ),
    );
    
  }
}