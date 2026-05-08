/*
 * Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.
 */

import 'package:flutter/material.dart';

import 'colors.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.fieldLabelStyle,
    required this.fieldErrorStyle,
    required this.secondaryButtonBackground,
    required this.secondaryButtonForeground,
  });

  final TextStyle fieldLabelStyle;
  final TextStyle fieldErrorStyle;
  final Color secondaryButtonBackground;
  final Color secondaryButtonForeground;

  @override
  AppThemeExtension copyWith({
    TextStyle? fieldLabelStyle,
    TextStyle? fieldErrorStyle,
    Color? secondaryButtonBackground,
    Color? secondaryButtonForeground,
  }) {
    return AppThemeExtension(
      fieldLabelStyle: fieldLabelStyle ?? this.fieldLabelStyle,
      fieldErrorStyle: fieldErrorStyle ?? this.fieldErrorStyle,
      secondaryButtonBackground:
          secondaryButtonBackground ?? this.secondaryButtonBackground,
      secondaryButtonForeground:
          secondaryButtonForeground ?? this.secondaryButtonForeground,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      fieldLabelStyle:
          TextStyle.lerp(fieldLabelStyle, other.fieldLabelStyle, t) ??
          fieldLabelStyle,
      fieldErrorStyle:
          TextStyle.lerp(fieldErrorStyle, other.fieldErrorStyle, t) ??
          fieldErrorStyle,
      secondaryButtonBackground:
          Color.lerp(
            secondaryButtonBackground,
            other.secondaryButtonBackground,
            t,
          ) ??
          secondaryButtonBackground,
      secondaryButtonForeground:
          Color.lerp(
            secondaryButtonForeground,
            other.secondaryButtonForeground,
            t,
          ) ??
          secondaryButtonForeground,
    );
  }
}

abstract final class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    scaffoldBackgroundColor: AppColors.gray100,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      },
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.gray10,
      contentTextStyle: TextStyle(color: AppColors.gray100),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: AppColors.gray90,
      hintStyle: const TextStyle(color: AppColors.gray50),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.gray50),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.gray50),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.purple40, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.red50),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.red50, width: 1.2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.purple40,
        foregroundColor: AppColors.gray100,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.gray05),
      bodyMedium: TextStyle(color: AppColors.gray05),
      titleMedium: TextStyle(color: AppColors.gray05),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppThemeExtension(
        fieldLabelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.gray05,
        ),
        fieldErrorStyle: TextStyle(fontSize: 12, color: AppColors.red50),
        secondaryButtonBackground: AppColors.purple90,
        secondaryButtonForeground: AppColors.purple40,
      ),
    ],
  );
}
