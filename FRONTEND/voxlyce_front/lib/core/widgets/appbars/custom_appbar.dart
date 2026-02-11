import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Premium Custom AppBar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? elevation;

  const CustomAppBar({
    this.title,
    this.titleWidget,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.iconColor,
    this.elevation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: iconColor ?? (isDarkMode ? AppColors.kWhite : AppColors.kSecondary),
                size: AppSpacing.iconMd,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTypography.kHeading5.copyWith(
                    color: iconColor ?? (isDarkMode ? AppColors.kWhite : AppColors.kSecondary),
                  ),
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Transparent AppBar with gradient background
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Gradient? gradient;

  const GradientAppBar({
    this.title,
    this.onBackPressed,
    this.actions,
    this.gradient,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.kWhite,
            size: AppSpacing.iconMd,
          ),
          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        ),
        title: title != null
            ? Text(
                title!,
                style: AppTypography.kHeading5.copyWith(
                  color: AppColors.kWhite,
                ),
              )
            : null,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
