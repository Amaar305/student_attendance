import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';


class AttendanceRow extends StatelessWidget {
  final int percent;
  final Color ringColor;
  final String date;
  final String time;
  final String fraction;
  final VoidCallback? onTap;

  const AttendanceRow({
    super.key,
    required this.percent,
    required this.ringColor,
    required this.date,
    required this.time,
    required this.fraction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final subtleShadow = BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 18,
      offset: const Offset(0, 8),
    );

    return Tappable.faded(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ringColor.withValues(alpha: 0.08),
                const Color(0xFFF8FAFC),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [subtleShadow],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                _RingPercent(percent: percent, ringColor: ringColor),
                Gap.h(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 6,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontWeight: AppFontWeight.semiBold,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        spacing: AppSpacing.xs,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 15,
                            color: Colors.grey.shade500,
                          ),

                          Expanded(
                            child: Text(
                              time,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: ringColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          fraction,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: ringColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap.h(AppSpacing.xs),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 25,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




class _RingPercent extends StatelessWidget {
  final int percent;
  final Color ringColor;

  const _RingPercent({required this.percent, required this.ringColor});

  @override
  Widget build(BuildContext context) {
    // Matches the visual: colored ring with lighter remainder.
    return SizedBox(
      width: 38,
      height: 38,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 38,
            height: 38,
            child: CircularProgressIndicator(
              value: percent / 100.0,
              strokeWidth: 2,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(ringColor),
            ),
          ),
          Text(
            '$percent%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ringColor,
            ),
          ),
        ],
      ),
    );
  }
}
