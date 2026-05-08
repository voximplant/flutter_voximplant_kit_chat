// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color gray05 = Color(0xFF191620);
  static const Color gray10 = Color(0xFF1F1C28);
  static const Color gray50 = Color(0xFF72727A);
  static const Color gray90 = Color(0xFFF4F4F4);
  static const Color gray100 = Color(0xFFFFFFFF);
  static const Color purple40 = Color(0xFF662EFF);
  static const Color purple90 = Color(0xFFF1ECFF);
  static const Color red50 = Color(0xFFF74E57);
  static const Color red95 = Color(0xFFFFF1F1);

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.purple40,
    onPrimary: AppColors.gray100,
    secondary: AppColors.gray90,
    onSecondary: AppColors.gray05,
    surface: AppColors.gray100,
    onSurface: AppColors.gray05,
    error: AppColors.red50,
    onError: AppColors.gray100,
  );
}
