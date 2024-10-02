import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socrita/core/routes/routes.dart';
import 'package:socrita/core/theme/app_theme.dart';
import 'package:socrita/features/canvas/presentation/controllers/home_controller.dart';

import 'features/canvas/presentation/controllers/deepgram_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(HomeController());
  Get.put(DeepgramController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final fontFamilyFallback = <String>[];
    fontFamilyFallback.add("Apple Color Emoji");

    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Socrita',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkThemeMode(fontFamilyFallback),
          themeMode: ThemeMode.dark,
          initialRoute: AppRoutes.introScreen,
          getPages: AppRoutes.routes,
        );
      },
    );
  }
}
