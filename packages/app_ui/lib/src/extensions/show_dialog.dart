import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

/// The signature for the callback that uses the [BuildContext].
typedef BuildContextCallback = void Function(BuildContext context);

/// {@template show_dialog_extension}
/// Dialog extension that shows dialog with optional `title`,
/// `content` and `actions`.
/// {@endtemplate}
extension DialogExtension on BuildContext {
  /// Shows the bottom sheet with the confirmation of the `action`.
  Future<bool?> showConfirmationBottomSheet({
    required String title,
    required String okText,
    String? description,
    String? cancelText,
    VoidCallback? onCancel,
    VoidCallback? onDone,
    bool showIcon = true,
    bool dismissible = false,
  }) {
    return showModalBottomSheet(
      context: this,
      isDismissible: dismissible,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: context.screenHeight * 0.34,
          child: AppConstrainedScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.spaceUnit),
              child: Column(
                spacing: AppSpacing.md,
                children: [
                  if (showIcon)
                    Assets.images.circleCheck.image(
                      width: 77,
                      height: 77,
                    ),
                  Text(
                    title,
                    style: context.titleMedium,
                  ),
                  if (description != null)
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: AppFontWeight.extraLight,
                      ),
                    ),
                  const Gap.v(AppSpacing.spaceUnit / 2),
                  PrimaryButton(
                    label: okText,
                    onPressed: onCancel ?? onDone ?? () => pop(true),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ///
  Future<bool?> showExtraBottomSheet({
    required String title,
    String? description,
    Widget? icon,
    List<Widget>? children,
    bool dismissible = true,
  }) {
    return showModalBottomSheet(
      isDismissible: dismissible,
      context: this,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) => SizedBox(
        height: context.screenHeight * 0.45,
        child: AppConstrainedScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              spacing: AppSpacing.md,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  SizedBox.square(
                    dimension: 77,
                    child: icon,
                  ),
                Text(
                  title,
                  style: context.titleMedium,
                ),
                if (description != null)
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: AppFontWeight.extraLight,
                    ),
                  ),
                const Gap.v(AppSpacing.spaceUnit / 2),
                if (children != null)
                  Column(
                    spacing: AppSpacing.md,
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows a standard failure bottom sheet with retry/back actions.
  Future<T?> showFailureBottomSheet<T>({
    String title = 'Transaction failed',
    String? message,
    Widget? details,
    String primaryLabel = 'Retry',
    VoidCallback? onPrimary,
    String secondaryLabel = 'Go Back',
    VoidCallback? onSecondary,
    bool dismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isDismissible: dismissible,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.md,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.red,
                size: AppSpacing.xxxlg,
              ),
              Text(title, style: sheetContext.titleMedium),
              if (message != null && message.isNotEmpty)
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.emphasizeGrey,
                    fontSize: 13,
                  ),
                ),
              if (details != null) details,
              PrimaryButton(
                label: primaryLabel,
                onPressed: () {
                  sheetContext.pop();
                  onPrimary?.call();
                },
              ),
              SizedBox(
                width: double.infinity,
                child: AppOutlinedButton(
                  isLoading: false,
                  label: secondaryLabel,
                  onPressed: () {
                    sheetContext.pop();
                    onSecondary?.call();
                  },
                ),
              ),
              const Gap.v(AppSpacing.spaceUnit),
            ],
          ),
        );
      },
    );
  }

  /// Shows the bottom sheet for saving beneficiiary with the confirmation
  ///  of the `action`.
  Future<bool?> showBeneficiaryConfirmationBottomSheet({
    required String title,
    required String okText,
    String? description,
    String? cancelText,
    VoidCallback? onSaved,
    VoidCallback? onRate,
  }) {
    return showModalBottomSheet(
      context: this,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: context.screenHeight * 0.45,
          child: AppConstrainedScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                spacing: AppSpacing.md,
                children: [
                  Assets.images.circleCheck.image(
                    width: 77,
                    height: 77,
                  ),
                  Text(
                    title,
                    style: context.titleMedium,
                  ),
                  if (description != null)
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: AppFontWeight.extraLight,
                      ),
                    ),
                  const Gap.v(AppSpacing.spaceUnit / 2),
                  PrimaryButton(
                    label: okText,
                    onPressed: () => pop(true),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppOutlinedButton(
                          isLoading: false,
                          label: 'Save as Beneficiary',
                          onPressed: onSaved,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: onSaved,
                    child: const Text(
                      'Rate us',
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 16,
                        fontWeight: AppFontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Shows adaptive dialog with provided `title`, `content` and `actions`
  /// (if provided). If `barrierDismissible` is `true` (default), dialog can't
  /// be dismissed by tapping outside of the dialog.
  Future<T?> showAdaptiveDialog<T>({
    String? content,
    String? title,
    List<Widget> actions = const [],
    bool barrierDismissible = true,
    Widget Function(BuildContext)? builder,
    TextStyle? titleTextStyle,
  }) =>
      showDialog<T>(
        context: this,
        barrierDismissible: barrierDismissible,
        builder: builder ??
            (context) {
              return AlertDialog.adaptive(
                actionsAlignment: MainAxisAlignment.end,
                title: Text(title!),
                titleTextStyle: titleTextStyle,
                content: content == null ? null : Text(content),
                actions: actions,
              );
            },
      );

  /// Shows bottom modal.
  Future<T?> showBottomModal<T>({
    Widget Function(BuildContext context)? builder,
    String? title,
    Color? titleColor,
    Widget? content,
    Color? backgroundColor,
    Color? barrierColor,
    ShapeBorder? border,
    bool rounded = true,
    bool isDismissible = true,
    bool isScrollControlled = false,
    bool enableDrag = true,
    bool useSafeArea = true,
    bool showDragHandle = true,
  }) =>
      showModalBottomSheet(
        context: this,
        shape: border ??
            (!rounded
                ? null
                : const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  )),
        showDragHandle: showDragHandle,
        backgroundColor: backgroundColor,
        barrierColor: barrierColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        useSafeArea: useSafeArea,
        isScrollControlled: isScrollControlled,
        useRootNavigator: true,
        builder: builder ??
            (context) {
              return Material(
                type: MaterialType.transparency,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      Text(
                        title,
                        style: context.titleLarge?.copyWith(color: titleColor),
                      ),
                      const Divider(),
                    ],
                    content!,
                  ],
                ),
              );
            },
      );

  /// Shows bottom modal with a `list` of [ModalOption]s
  Future<ModalOption?> showListOptionsModal({
    required List<ModalOption> options,
    String? title,
  }) =>
      showBottomModal<ModalOption>(
        isScrollControlled: true,
        title: title,
        content: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: options
                  .map(
                    (option) =>
                        option.child ??
                        Tappable.faded(
                          onTap: () => pop<ModalOption>(option),
                          child: ListTile(
                            title: option.name == null
                                ? null
                                : Text(
                                    option.name!,
                                    style: bodyLarge?.copyWith(
                                      color: option.nameColor ??
                                          option.distractiveColor,
                                    ),
                                  ),
                            leading:
                                option.icon == null && option.iconData == null
                                    ? null
                                    : option.icon ??
                                        Icon(
                                          option.iconData,
                                          color: option.distractiveColor,
                                        ),
                          ),
                        ),
                  )
                  .toList(),
            ),
          ),
        ),
      );

  /// Opens the modal bottom sheet for a comments page builder.
  Future<void> showScrollableModal({
    required Widget Function(
      ScrollController scrollController,
      DraggableScrollableController draggableScrollController,
    ) pageBuilder,
    double initialChildSize = .7,
    bool showFullSized = false,
  }) =>
      showBottomModal<void>(
        isScrollControlled: true,
        builder: (context) {
          final controller = DraggableScrollableController();
          return DraggableScrollableSheet(
            controller: controller,
            expand: false,
            snap: true,
            snapSizes: const [.6, 1],
            initialChildSize: showFullSized ? 1.0 : initialChildSize,
            minChildSize: .4,
            builder: (context, scrollController) =>
                pageBuilder.call(scrollController, controller),
          );
        },
      );

  /// Opens a dialog where shows a preview of an image in a circular avatar.
  Future<void> showImagePreview(String imageUrl) => showDialog<void>(
        context: this,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            backgroundColor: AppColors.transparent,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),
          );
        },
      );

  /// Shows the confirmation dialog and upon confirmation executes provided
  /// [fn].
  Future<void> confirmAction({
    required void Function() fn,
    required String title,
    required String noText,
    required String yesText,
    String? content,
    TextStyle? yesTextStyle,
    TextStyle? noTextStyle,
    BuildContextCallback? noAction,
  }) async {
    final isConfirmed = await showConfirmationDialog(
      title: title,
      content: content,
      noText: noText,
      yesText: yesText,
      yesTextStyle: yesTextStyle,
      noTextStyle: noTextStyle,
      noAction: noAction,
    );
    if (isConfirmed == null || !isConfirmed) return;
    fn.call();
  }

  /// Shows a dialog that alerts user that they are about to do distractive
  /// action.
  Future<bool?> showConfirmationDialog({
    required String title,
    required String noText,
    required String yesText,
    String? content,
    BuildContextCallback? noAction,
    BuildContextCallback? yesAction,
    TextStyle? noTextStyle,
    TextStyle? yesTextStyle,
    bool distractiveAction = true,
    bool barrierDismissible = true,
  }) =>
      showAdaptiveDialog<bool?>(
        title: title,
        content: content,
        barrierDismissible: barrierDismissible,
        titleTextStyle: headlineSmall,
        actions: [
          AppButton(
            isDialogButton: true,
            isDefaultAction: true,
            onPressed: () => noAction == null
                ? (canPop() ? pop(false) : null)
                : noAction.call(this),
            text: noText,
            textStyle: noTextStyle ?? labelLarge?.apply(color: adaptiveColor),
          ),
          AppButton(
            isDialogButton: true,
            isDestructiveAction: true,
            onPressed: () => yesAction == null
                ? (canPop() ? pop(true) : null)
                : yesAction.call(this),
            text: yesText,
            textStyle: yesTextStyle ?? labelLarge?.apply(color: AppColors.red),
          ),
        ],
      );
}
