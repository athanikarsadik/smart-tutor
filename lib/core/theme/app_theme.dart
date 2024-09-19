import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.backgroundColor,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.backgroundColor),
    chipTheme: const ChipThemeData(
        color: WidgetStatePropertyAll(AppColors.backgroundColor),
        side: BorderSide.none),
  );
}
