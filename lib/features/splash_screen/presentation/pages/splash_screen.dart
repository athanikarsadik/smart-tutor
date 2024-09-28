import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socratica/core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvasPrimaryColor,
      ),
      child: Center(
        child: CircleAvatar(
          backgroundColor: AppColors.primaryColor,
          radius: 20.r,
        ),
      ),
    );
  }
}
