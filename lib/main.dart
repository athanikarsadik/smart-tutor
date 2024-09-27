import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socratica/core/theme/app_theme.dart';
import 'package:socratica/features/canvas/presentation/pages/canvas_screen.dart';
import 'package:socratica/features/home/presentation/controller/home_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(HomeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Socratica',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkThemeMode,
          home: const DrawingApp(),
        );
      },
    );
  }
}
