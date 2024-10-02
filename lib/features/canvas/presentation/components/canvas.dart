import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'widgets/drawing_canvas.dart';

class CanvasWidget extends StatelessWidget {
  const CanvasWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => RepaintBoundary(
        key: controller.canvasGlobalKey,
        child: Container(
          color: controller.selectedBgColor.value,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: const DrawingCanvas(),
          ),
        ),
      ),
    );
  }
}
