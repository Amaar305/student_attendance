import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/features/lecturer/presentation/course/model/course_stat.dart';

class CourseStatCard extends StatelessWidget {
  const CourseStatCard({super.key, required this.stat});

  final CourseStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      height: context.screenHeight * 0.16,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (stat.accentColor ?? AppColors.blue).withValues(alpha: 0.14),
            AppColors.brightGrey.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.brightGrey.withValues(alpha: 0.35)),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          Row(
            spacing: AppSpacing.sm,
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: (stat.accentColor ?? AppColors.blue).withValues(
                    alpha: 0.15,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  stat.icon,
                  color: stat.accentColor ?? AppColors.blue,
                  size: 20,
                ),
              ),
              Flexible(
                child: Text(
                  stat.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.labelMedium?.copyWith(
                    color: AppColors.emphasizeGrey,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ),
            ],
          ),

          Text(
            stat.value,
            textAlign: TextAlign.center,
            style: context.headlineMedium?.copyWith(
              fontWeight: AppFontWeight.bold,
            ),
          ),

          Text(
            stat.subtitle,
            style: context.bodyMedium?.copyWith(
              fontWeight: AppFontWeight.semiBold,
              color: stat.subtitleColor ?? AppColors.emphasizeGrey,
            ),
          ),
        ],
      ),
    );
  }
}
