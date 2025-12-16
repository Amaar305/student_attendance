import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A reusable shell for authentication screens that provides
/// the frosted card, hero header, and ambient background.
class AuthShell extends StatelessWidget {
  const AuthShell({
    required this.title,
    required this.subtitle,
    required this.formFields,
    required this.primaryAction,
    this.meta,
    this.footer,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<Widget> formFields;
  final Widget primaryAction;
  final Widget? meta;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: true,
      safeArea: false,
      releaseFocus: true,
      body: Stack(
        children: [
          const _AuthBackdrop(),
          AppConstrainedScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xlg,
              vertical: AppSpacing.xxxlg,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: _FrostedCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Align(child: AppLogo(height: 70, width: 70)),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDarkBlue,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.emphasizeGrey,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxlg),
                      ..._withSpacing(formFields, spacing: AppSpacing.lg),
                      if (meta != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        meta!,
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      primaryAction,
                      if (footer != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        footer!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<Widget> _withSpacing(
    List<Widget> children, {
    double spacing = AppSpacing.lg,
  }) {
    if (children.isEmpty) return children;
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i != children.length - 1) {
        spaced.add(SizedBox(height: spacing));
      }
    }
    return spaced;
  }
}

class _AuthBackdrop extends StatelessWidget {
  const _AuthBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryDarkBlue, AppColors.deepBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -40,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lightBlue.withValues(alpha: 0.15),
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          left: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blue.withValues(alpha: 0.2),
            ),
          ),
        ),
      ],
    );
  }
}

class _FrostedCard extends StatelessWidget {
  const _FrostedCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
        border: Border.all(color: AppColors.lightBlueFilled),
      ),
      padding: const EdgeInsets.all(AppSpacing.xlg),
      child: child,
    );
  }
}
