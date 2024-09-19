import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/calculator_controller.dart';

class ColorPalette extends StatelessWidget {
  const ColorPalette({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 10.w,
      runSpacing: 10.h,
      children: _buildColorCircles(),
    );
  }

  List<Widget> _buildColorCircles() {
    List<Color> colors = [
      Colors.black,
      Colors.white,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.cyan,
      Colors.cyanAccent,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];

    return colors
        .map((color) => ColorCircle(
              color: color,
            ))
        .toList();
  }
}

class ColorCircle extends StatelessWidget {
  final Color color;
  final controller = Get.find<CalculatorController>();

  ColorCircle({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            controller.selectedColor.value = MaterialColor(color.value, {});
          },
          child: Container(
            height: 25.sp,
            width: 25.sp,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: controller.selectedColor.value ==
                        MaterialColor(color.value, {})
                    ? Colors.cyanAccent
                    : Colors.grey,
                width: 1.5,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
      ),
    );
  }
}
