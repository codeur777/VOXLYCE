import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Premium Text Field with modern design
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon; // Changed from IconData to Widget
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool enabled;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool autofocus;

  const CustomTextField({
    required this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  Color get _borderColor {
    if (widget.errorText != null) return AppColors.kError;
    if (_isFocused) return AppColors.kPrimary;
    return _isDarkMode ? AppColors.kGreyDark : AppColors.kGreyLight;
  }

  Color get _fillColor {
    if (!widget.enabled) {
      return _isDarkMode ? AppColors.kSecondaryLight : AppColors.kGreyLight;
    }
    return _isDarkMode ? AppColors.kSurfaceDark : AppColors.kWhite;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.kLabel.copyWith(
              color: _isDarkMode ? AppColors.kWhite : AppColors.kSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.smVertical),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _fillColor,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: _borderColor,
              width: _isFocused ? 2 : 1.5,
            ),
            boxShadow: _isFocused && widget.errorText == null
                ? [
                    BoxShadow(
                      color: AppColors.kPrimary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            onChanged: widget.onChanged,
            style: AppTypography.kBody1.copyWith(
              color: _isDarkMode ? AppColors.kWhite : AppColors.kSecondary,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTypography.kBody1.copyWith(
                color: AppColors.kGrey,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused ? AppColors.kPrimary : AppColors.kGrey,
                      size: AppSpacing.iconMd,
                    )
                  : null,
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: AppSpacing.xsVertical),
          Text(
            widget.errorText!,
            style: AppTypography.kCaption.copyWith(
              color: AppColors.kError,
            ),
          ),
        ],
      ],
    );
  }
}
