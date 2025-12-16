import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/app/cubit/app_cubit.dart';
import 'package:student_attendance/features/home/home.dart';

class HomeStudentView extends StatelessWidget {
  const HomeStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: HomeAppBarTitle(),
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
            HomeStudentQuickAction(),
            HomeStudentTodaysClasses(),
          ],
        ),
      ),
    );
  }
}
