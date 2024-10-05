import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socrita/core/routes/routes.dart';
import 'package:socrita/core/theme/app_theme.dart';
import 'package:socrita/init_dependencies.dart';
import 'package:toastification/toastification.dart';
import 'dart:io';

class BadCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = BadCertificateHttpOverrides();
  InitDependencies.init();
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
        return ToastificationWrapper(
          child: GetMaterialApp(
            title: 'Socrita',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkThemeMode(fontFamilyFallback),
            themeMode: ThemeMode.dark,
            initialRoute: AppRoutes.introScreen,
            getPages: AppRoutes.routes,
          ),
        );
      },
    );
  }
}
