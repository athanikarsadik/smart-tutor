import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:socrita/core/routes/routes.dart';
import 'package:socrita/features/intro_screen/presentation/components/gradient_ball.dart';
import 'package:socrita/features/intro_screen/presentation/components/gradient_text.dart';
import 'package:socrita/features/intro_screen/presentation/components/mesh_animation.dart';
import 'package:socrita/features/intro_screen/presentation/components/rive_button.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _introController;
  late Animation<double> _animation;

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[
      Color.fromARGB(255, 74, 74, 74),
      Color.fromARGB(255, 251, 251, 251)
    ],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -20.0, end: 20.0).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _introController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Positioned.fill(
            child: Opacity(opacity: 0.4, child: MeshAnimation()),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      left: 100.h,
                      top: 150 + _animation.value,
                      child: GradientBall(
                        size: 152.sp,
                        colors: const [Colors.blue, Colors.cyanAccent],
                      ),
                    ),
                    Positioned(
                      right: 120.h,
                      top: 300 - _animation.value,
                      child: GradientBall(
                        size: 200.sp,
                        colors: const [Colors.purpleAccent, Colors.pink],
                      ),
                    ),
                    Positioned(
                      left: 250.h,
                      bottom: 150 + _animation.value,
                      child: GradientBall(
                        size: 100.sp,
                        colors: const [Colors.orange, Colors.redAccent],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 20.w,
            right: 20.w,
            child: Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // GradientText(
                      //   'Welcome, ',
                      //   style: TextStyle(
                      //     fontSize: 100.sp,
                      //     fontWeight: FontWeight.w900,
                      //     shadows: [
                      //       Shadow(
                      //         blurRadius: 5,
                      //         color: const Color.fromARGB(255, 70, 70, 70)
                      //             .withOpacity(0.0),
                      //         offset: const Offset(0, 4),
                      //       ),
                      //     ],
                      //   ),
                      //   gradient: const LinearGradient(
                      //     begin: Alignment.topCenter,
                      //     end: Alignment.bottomCenter,
                      //     colors: [
                      //       Color.fromARGB(255, 255, 255, 255),
                      //       Color.fromARGB(255, 255, 255, 255),
                      //       Color.fromARGB(255, 0, 0, 0),
                      //     ],
                      //   ),
                      // ),
                      SvgPicture.asset(
                        "assets/svg/logo.svg",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60.h),
                GradientText(
                  'Igniting Minds Through Socratic Learning – Where Questions Lead to Mastery',
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: const Color.fromARGB(255, 70, 70, 70)
                            .withOpacity(0.0),
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 0, 0, 0),
                    ],
                  ),
                ),
                SizedBox(height: 140.h),
                GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.homeScreen);
                    },
                    child: RiveButtonAnimation())
                // AnimatedButton(
                //   onPressed: () {
                //     Get.toNamed(AppRoutes.homeScreen);
                //   },
                //   text: 'Get Started',
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
