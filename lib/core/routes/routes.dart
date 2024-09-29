import 'package:get/get.dart';
import 'package:socratica/features/intro_screen/presentation/pages/intro_screen.dart';

import '../../features/canvas/presentation/pages/canvas_screen.dart';

class AppRoutes {
  static const String introScreen = "/";
  static const String homeScreen = "/canvas";

  static String getIntroScreen() => introScreen;
  static String getHomeScreen() => homeScreen;

  static List<GetPage> routes = [
    GetPage(
      name: introScreen,
      page: () => const IntroScreen(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: homeScreen,
      page: () => const DrawingApp(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(seconds: 1),
    ),
  ];
}
