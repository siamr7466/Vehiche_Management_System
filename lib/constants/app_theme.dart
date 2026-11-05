import 'package:flutter/material.dart';

/// Central Design System: Colors & Tokens
/// Exactly matches the specification:
/// #1F4E79 - Deep Blue (Navigation / Headings)
/// #5B9BD5 - Corporate Blue (Primary Actions / Highlights)
/// #F5F7FA - Soft Gray (Page Background)
/// #FFFFFF - White (Cards / Forms / Tables)
/// #1F2937 - Charcoal (Main Text)
/// #2E7D32 - Green (Active / Success)
/// #D32F2F - Red (Delete / Error only)
class AppColors {
  // 1. Specified Primary Palette
  static const Color deepBlue = Color(0xFF1F4E79);      // Navigation / Headings
  static const Color corporateBlue = Color(0xFF5B9BD5); // Primary Actions / Highlights
  static const Color softGray = Color(0xFFF5F7FA);      // Page Background
  static const Color white = Color(0xFFFFFFFF);         // Cards / Forms / Tables
  static const Color charcoal = Color(0xFF1F2937);      // Main Text
  static const Color green = Color(0xFF2E7D32);         // Active / Success
  static const Color red = Color(0xFFD32F2F);           // Delete / Error only

  // Component Tints & Semantic Aliases
  static const Color primary = corporateBlue;           // Primary Buttons & Highlights
  static const Color navigation = deepBlue;             // Sidebar & Page Headings
  static const Color background = softGray;             // Scaffold Background
  static const Color surface = white;                   // Cards, Tables, Modals
  static const Color surfaceAlt = softGray;             // Alternate row / container
  static const Color tableHeaderBg = softGray;          // Table header surface
  static const Color textPrimary = charcoal;            // High-contrast reading
  static const Color textSecondary = Color(0xFF4B5563); // Gray 600
  static const Color textMuted = Color(0xFF9CA3AF);     // Gray 400

  // Subtle Borders
  static const Color border = Color(0xFFE5E7EB);        // Gray 200
  static const Color borderSubtle = Color(0xFFF3F4F6);  // Gray 100

  // Semantic Status Colors
  static const Color active = green;                    // Green #2E7D32
  static const Color activeBg = Color(0xFFE8F5E9);      // Soft Green tint for Active Badge
  static const Color activeBorder = Color(0xFFC8E6C9);

  static const Color maintenance = Color(0xFFF57C00);   // Amber 700
  static const Color maintenanceBg = Color(0xFFFFF3E0); // Soft Amber tint
  static const Color maintenanceBorder = Color(0xFFFFE0B2);

  static const Color inactive = red;                    // Red #D32F2F
  static const Color inactiveBg = Color(0xFFFFEBEE);
  static const Color inactiveBorder = Color(0xFFFFCDD2);

  static const Color deleteBg = Color(0xFFFFEBEE);      // Soft Red tint for Delete Action
  static const Color deleteBorder = Color(0xFFFFCDD2);

  // Soft Background Tints
  static const Color primaryLight = Color(0xFFEBF3FA);  // Soft Corporate Blue tint

  // Action Colors
  static const Color actionView = Color(0xFF0F766E);     // Teal 700
  static const Color actionEdit = corporateBlue;        // Corporate Blue #5B9BD5
  static const Color actionDelete = red;                // Red #D32F2F
}

/// Central Design System: Spacing & Geometry Scale
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Geometry
  static const double radiusBadge = 6.0;
  static const double radiusInput = 8.0;
  static const double radiusButton = 8.0;
  static const double radiusCard = 10.0;
  static const double radiusDialog = 14.0;
  static const double radiusPill = 20.0;

  // Standard heights
  static const double buttonHeight = 42.0;
  static const double inputHeight = 44.0;
  static const double topBarHeight = 60.0;
}

/// Central Design System: Unified Typography
class AppTypography {
  static const String fontFamily = 'Segoe UI';

  static const TextStyle pageHeading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.deepBlue, // Headings use Deep Blue #1F4E79
    letterSpacing: -0.3,
  );

  static const TextStyle pageTitle = pageHeading;

  static const TextStyle dialogHeading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.deepBlue,
    letterSpacing: -0.2,
  );

  static const TextStyle dialogTitle = dialogHeading;

  static const TextStyle cardHeading = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.deepBlue,
  );

  static const TextStyle cardTitle = cardHeading;

  static const TextStyle tableHeader = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    color: AppColors.deepBlue,
    letterSpacing: 0.5,
  );

  static const TextStyle body = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.normal,
    color: AppColors.charcoal, // Main Text #1F2937
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    color: AppColors.charcoal,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
}

/// Central Design System: Theme Configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.corporateBlue,
        primary: AppColors.corporateBlue,
        onPrimary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.charcoal,
        surfaceContainerHighest: AppColors.primaryLight,
        outline: AppColors.border,
      ),

      // Clean AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.deepBlue,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Color(0x0D000000),
        centerTitle: false,
        titleTextStyle: AppTypography.pageHeading,
      ),

      // Unified Cards
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),

      // Form Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13.5),
        labelStyle: const TextStyle(color: AppColors.charcoal, fontSize: 13.5, fontWeight: FontWeight.w500),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: const BorderSide(color: AppColors.corporateBlue, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: const BorderSide(color: AppColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: const BorderSide(color: AppColors.red, width: 1.8),
        ),
      ),

      // Primary Buttons (#5B9BD5 Corporate Blue)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.corporateBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, AppSpacing.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
          ),
          textStyle: AppTypography.button,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.charcoal,
          minimumSize: const Size(0, AppSpacing.buttonHeight),
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
          ),
          textStyle: AppTypography.button.copyWith(color: AppColors.charcoal),
        ),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusDialog),
        ),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: AppSpacing.xxl,
      ),
    );
  }
}
