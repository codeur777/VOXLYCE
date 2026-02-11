import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Premium Card Widget with elevation and smooth shadows
class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? width;
  final double? height;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool hasShadow;
  final Border? border;
  final Gradient? gradient;

  const PremiumCard({
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
    this.hasShadow = true,
    this.border,
    this.gradient,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Widget cardContent = Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(AppSpacing.cardPaddingMd),
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null
            ? (color ?? (isDarkMode ? AppColors.kSurfaceDark : AppColors.kWhite))
            : null,
        gradient: gradient,
        border: border,
        boxShadow: hasShadow
            ? [
                if (isDarkMode)
                  AppColors.darkShadow
                else
                  AppColors.cardShadow,
              ]
            : null,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSpacing.radiusMd,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSpacing.radiusMd,
        ),
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// Elevated Card with stronger shadow
class ElevatedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;

  const ElevatedCard({
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Widget cardContent = Container(
      padding: padding ?? EdgeInsets.all(AppSpacing.cardPaddingLg),
      margin: margin,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.kSurfaceDark : AppColors.kWhite,
        boxShadow: AppColors.elevatedShadow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// Gradient Card
class GradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const GradientCard({
    required this.child,
    this.padding,
    this.margin,
    this.gradient,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: padding,
      margin: margin,
      gradient: gradient ?? AppColors.primaryGradient,
      onTap: onTap,
      child: child,
    );
  }
}
