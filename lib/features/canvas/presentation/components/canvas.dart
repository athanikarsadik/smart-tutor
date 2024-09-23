import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socratica/features/home/presentation/widgets/drawing_canvas.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/controller/home_controller.dart';

class CanvasWidget extends StatelessWidget {
  const CanvasWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => RepaintBoundary(
        key: controller.canvasGlobalKey,
        child: Container(
          color: AppColors.canvasPrimaryColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: const DrawingCanvas(),
          ),
        ),
      ),
    );
  }
}
