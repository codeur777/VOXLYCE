import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// Voxlyce Premium Typography System
class AppTypography {
  // Display Styles - For hero sections
  static TextStyle kDisplay1 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 48.sp,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle kDisplay2 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 40.sp,
    height: 1.2,
    letterSpacing: -0.5,
  );

  // Heading Styles
  static TextStyle kHeading1 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 32.sp,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static TextStyle kHeading2 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 28.sp,
    height: 1.3,
    letterSpacing: -0.2,
  );

  static TextStyle kHeading3 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 24.sp,
    height: 1.4,
  );

  static TextStyle kHeading4 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20.sp,
    height: 1.4,
  );

  static TextStyle kHeading5 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18.sp,
    height: 1.4,
  );

  // Body Styles
  static TextStyle kBody1 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: 1.5,
  );

  static TextStyle kBody2 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: 1.5,
  );

  static TextStyle kBody1Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
    height: 1.5,
  );

  static TextStyle kBody2Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    height: 1.5,
  );

  // Caption & Small Text
  static TextStyle kCaption = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    height: 1.4,
  );

  static TextStyle kCaptionMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    height: 1.4,
  );

  static TextStyle kSmall = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10.sp,
    height: 1.4,
  );

  // Button Styles
  static TextStyle kButton = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    height: 1.2,
    letterSpacing: 0.5,
  );

  static TextStyle kButtonSmall = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // Label Styles
  static TextStyle kLabel = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    height: 1.2,
    letterSpacing: 0.3,
  );

  static TextStyle kLabelSmall = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    height: 1.2,
    letterSpacing: 0.3,
  );

  // Utility Methods
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  // Predefined Color Combinations
  static TextStyle get kHeading1Primary => kHeading1.copyWith(color: AppColors.kPrimary);
  static TextStyle get kHeading1Secondary => kHeading1.copyWith(color: AppColors.kSecondary);
  static TextStyle get kHeading1White => kHeading1.copyWith(color: AppColors.kWhite);

  static TextStyle get kBody1Grey => kBody1.copyWith(color: AppColors.kGrey);
  static TextStyle get kBody1Secondary => kBody1.copyWith(color: AppColors.kSecondary);
  static TextStyle get kBody1White => kBody1.copyWith(color: AppColors.kWhite);

  static TextStyle get kButtonWhite => kButton.copyWith(color: AppColors.kWhite);
  static TextStyle get kButtonPrimary => kButton.copyWith(color: AppColors.kPrimary);
}
