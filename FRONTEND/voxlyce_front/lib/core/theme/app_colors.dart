import 'package:flutter/material.dart';

/// Voxlyce Premium Color Palette
/// Inspired by modern voting systems with trust and transparency
class AppColors {
  // Primary Colors - Voting Theme
  static const Color kPrimary = Color(0xFF2563EB); // Professional Blue
  static const Color kPrimaryDark = Color(0xFF1E40AF);
  static const Color kPrimaryLight = Color(0xFF60A5FA);
  
  // Secondary Colors
  static const Color kSecondary = Color(0xFF1E293B); // Dark Slate
  static const Color kSecondaryLight = Color(0xFF334155);
  
  // Accent Colors
  static const Color kAccent1 = Color(0xFF10B981); // Success Green
  static const Color kAccent2 = Color(0xFFF59E0B); // Warning Amber
  static const Color kAccent3 = Color(0xFFEF4444); // Error Red
  static const Color kAccent4 = Color(0xFF8B5CF6); // Purple
  
  // Neutral Colors
  static const Color kWhite = Color(0xFFFFFFFF);
  static const Color kBlack = Color(0xFF000000);
  static const Color kGrey = Color(0xFF64748B);
  static const Color kGreyLight = Color(0xFFF1F5F9);
  static const Color kGreyDark = Color(0xFF475569);
  
  // Background Colors
  static const Color kBackground = Color(0xFFF8FAFC);
  static const Color kBackgroundDark = Color(0xFF0F172A);
  static const Color kSurface = Color(0xFFFFFFFF);
  static const Color kSurfaceDark = Color(0xFF1E293B);
  
  // Status Colors
  static const Color kSuccess = Color(0xFF10B981);
  static const Color kWarning = Color(0xFFF59E0B);
  static const Color kError = Color(0xFFEF4444);
  static const Color kInfo = Color(0xFF3B82F6);
  
  // Voting Status Colors
  static const Color kPending = Color(0xFFF59E0B);
  static const Color kOngoing = Color(0xFF10B981);
  static const Color kValidated = Color(0xFF8B5CF6);
  static const Color kRejected = Color(0xFFEF4444);
  
  // Shadows
  static BoxShadow get defaultShadow => BoxShadow(
    color: kPrimary.withOpacity(0.15),
    blurRadius: 12,
    offset: const Offset(0, 4),
    spreadRadius: 0,
  );

  static BoxShadow get darkShadow => BoxShadow(
    color: kSecondary.withOpacity(0.2),
    blurRadius: 12,
    offset: const Offset(0, 4),
    spreadRadius: 0,
  );

  static BoxShadow get cardShadow => BoxShadow(
    color: kBlack.withOpacity(0.08),
    blurRadius: 16,
    offset: const Offset(0, 2),
    spreadRadius: 0,
  );

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: kPrimary.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: kBlack.withOpacity(0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  // Gradients
  static LinearGradient get primaryGradient => const LinearGradient(
    colors: [kPrimary, kPrimaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get successGradient => const LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get backgroundGradient => const LinearGradient(
    colors: [kBackground, kWhite],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
