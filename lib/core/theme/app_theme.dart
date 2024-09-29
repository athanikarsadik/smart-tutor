import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.backgroundColor,
    primaryColor: AppColors.backgroundColor,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.backgroundColor),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Spinnaker'),
      bodyMedium: TextStyle(fontFamily: 'Spinnaker'),
      bodySmall: TextStyle(fontFamily: 'Spinnaker'),
      displayLarge: TextStyle(fontFamily: 'Spinnaker'),
      displayMedium: TextStyle(fontFamily: 'Spinnaker'),
      displaySmall: TextStyle(fontFamily: 'Spinnaker'),
      headlineLarge: TextStyle(fontFamily: 'Spinnaker'),
      titleMedium: TextStyle(fontFamily: 'Spinnaker'),
      headlineMedium: TextStyle(fontFamily: 'Spinnaker'),
      headlineSmall: TextStyle(fontFamily: 'Spinnaker'),
      labelLarge: TextStyle(fontFamily: 'Spinnaker'),
      labelMedium: TextStyle(fontFamily: 'Spinnaker'),
      labelSmall: TextStyle(fontFamily: 'Spinnaker'),
      titleLarge: TextStyle(fontFamily: 'Spinnaker'),
      titleSmall: TextStyle(fontFamily: 'Spinnaker'),
    ),
    chipTheme: const ChipThemeData(
        color: WidgetStatePropertyAll(AppColors.backgroundColor),
        side: BorderSide.none),
  );
}
