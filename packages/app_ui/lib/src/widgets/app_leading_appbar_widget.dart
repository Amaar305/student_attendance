// ignore_for_file: lines_longer_than_80_chars

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A custom widget that provides a leading widget for an AppBar.
///
/// This widget is typically used to display a leading icon or button
/// in the AppBar, such as a back button or a menu button.
///
/// {@tool snippet}
/// This example shows how to use [AppLeadingAppBarWidget] in an AppBar:
///
/// ```dart
/// AppBar(
///   leading: AppLeadingAppBarWidget(),
///   title: Text('App Bar Title'),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [AppBar], which is the material design app bar.
///  * [IconButton], which is typically used as a leading widget.
class AppLeadingAppBarWidget extends StatelessWidget {
  /// A widget that provides a leading widget for an AppBar with an optional tap callback.
  ///
  /// The [AppLeadingAppBarWidget] can be used to add a custom leading widget to an AppBar,
  /// typically used for navigation purposes.
  ///
  /// The [onTap] parameter is an optional callback that will be triggered when the leading
  /// widget is tapped.
  ///
  /// Example usage:
  /// ```dart
  /// AppBar(
  ///   leading: AppLeadingAppBarWidget(
  ///     onTap: () {
  ///       // Handle the tap event
  ///     },
  ///   ),
  /// )
  /// ```
  const AppLeadingAppBarWidget({super.key, this.onTap});

  /// A callback function that is triggered when the leading widget in the app bar is tapped.
  ///
  /// This can be used to perform any action when the user interacts with the leading widget.
  ///
  /// Example usage:
  /// ```dart
  /// AppLeadingAppBarWidget(
  ///   onTap: () {
  ///     // Handle the tap event
  ///   },
  /// );
  /// ```
  ///
  /// If no action is needed, this can be set to `null`.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.adaptiveColor.withValues(alpha: 0.1),
        ),
      ),
      child: Tappable.scaled(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: const Icon(
          Icons.arrow_back_ios,
          size: 16,
        ),
      ),
    );
  }
}
