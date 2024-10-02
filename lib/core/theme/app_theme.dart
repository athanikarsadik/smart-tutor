import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData darkThemeMode(List<String> fontFamilyFallback) {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.backgroundColor,
      primaryColor: AppColors.backgroundColor,
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.backgroundColor),
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        bodyMedium: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        bodySmall: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        displayLarge: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        displayMedium: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        displaySmall: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        headlineLarge: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        titleMedium: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        headlineMedium: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        headlineSmall: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        labelLarge: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        labelMedium: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        labelSmall: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        titleLarge: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
        titleSmall: TextStyle(fontFamily: 'Spinnaker', fontFamilyFallback: fontFamilyFallback),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.backgroundColor,
        side: BorderSide.none,
      ),
    );
  }
}
