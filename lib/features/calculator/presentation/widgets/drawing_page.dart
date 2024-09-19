import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../controller/calculator_controller.dart';
import '../widgets/drawing_canvas.dart';

class DrawingPage extends StatelessWidget {
  const DrawingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalculatorController>(
      init: CalculatorController(),
      builder: (controller) => RepaintBoundary(
        key: controller.canvasGlobalKey,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.canvasBgColor,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5.r,
                blurRadius: 7.r,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: const DrawingCanvas(),
          ),
        ),
      ),
    );
  }
}
