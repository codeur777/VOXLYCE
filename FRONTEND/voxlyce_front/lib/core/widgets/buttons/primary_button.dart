import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Premium Primary Button with smooth animations
class PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final bool isOutlined;

  const PrimaryButton({
    required this.onTap,
    required this.text,
    this.width,
    this.height,
    this.borderRadius,
    this.color,
    this.textColor,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isOutlined = false,
    Key? key,
  }) : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 200);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.96);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  Color get _buttonColor {
    if (widget.isDisabled) {
      return AppColors.kGreyLight;
    }
    if (widget.isOutlined) {
      return Colors.transparent;
    }
    return widget.color ?? AppColors.kPrimary;
  }

  Color get _textColor {
    if (widget.isDisabled) {
      return AppColors.kGrey;
    }
    if (widget.isOutlined) {
      return widget.color ?? AppColors.kPrimary;
    }
    return widget.textColor ?? AppColors.kWhite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isDisabled || widget.isLoading
          ? null
          : () {
              _controller.forward().then((_) {
                _controller.reverse();
              });
              widget.onTap();
            },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Container(
          height: widget.height ?? AppSpacing.buttonHeightMd,
          width: widget.width ?? double.maxFinite,
          decoration: BoxDecoration(
            color: _buttonColor,
            border: widget.isOutlined
                ? Border.all(
                    color: widget.color ?? AppColors.kPrimary,
                    width: 2,
                  )
                : null,
            boxShadow: widget.isDisabled || widget.isOutlined
                ? null
                : [
                    if (_isDarkMode)
                      AppColors.darkShadow
                    else
                      AppColors.defaultShadow,
                  ],
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppSpacing.radiusMd,
            ),
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(_textColor),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: _textColor,
                          size: AppSpacing.iconSm,
                        ),
                        SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        widget.text,
                        style: AppTypography.kButton.copyWith(
                          color: _textColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
