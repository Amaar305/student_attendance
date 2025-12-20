import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class SegmentedToggle extends StatelessWidget {
  const SegmentedToggle({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    this.height = 46,
    this.padding = const EdgeInsets.all(6),
  }) : assert(options.length > 1, 'SegmentedToggle needs at least two options');

  final List<SegmentedToggleOption> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++)
            Expanded(
              child: Tappable(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: 200.ms,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == selectedIndex ? Colors.white : null,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: i == selectedIndex
                        ? const [
                            BoxShadow(
                              color: Color(0x11000000),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    options[i].label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: i == selectedIndex
                          ? const Color(0xFF111827)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


class SegmentedToggleOption {
  const SegmentedToggleOption({required this.label});

  final String label;
}
