import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_calculator/features/calculator/domain/entities/drawing_tool_entity.dart';
import 'package:smart_calculator/features/calculator/presentation/controller/calculator_controller.dart';

import '../../../../core/theme/app_colors.dart';
import 'color_palette_widget.dart';

class CalculatorDrawerAni extends StatelessWidget {
  CalculatorDrawerAni({super.key});

  final controller = Get.find<CalculatorController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primaryColor,
      elevation: 2,
      shadowColor: AppColors.borderColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            onPressed: () =>
                controller.isExpanded.value = !controller.isExpanded.value,
            icon: Icon(
              Icons.menu,
              color: AppColors.whiteColor,
              size: 25.sp,
            ),
          ),
          Expanded(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: controller.isExpanded.value
                  ? _buildExpandedContent()
                  : _buildCollapsedContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDrawingToolsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: [
          _IconBox(
            iconData: FontAwesomeIcons.arrowPointer,
            tooltip: 'Select',
            drawingTool: DrawingTool.select,
          ),
          _IconBox(
              iconData: FontAwesomeIcons.pencil,
              tooltip: 'Pencil',
              drawingTool: DrawingTool.pencil),
          _IconBox(
              iconData: FontAwesomeIcons.eraser,
              tooltip: 'Eraser',
              drawingTool: DrawingTool.eraser),
          _IconBox(
            tooltip: 'Line',
            drawingTool: DrawingTool.line,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 22,
                  height: 2,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          _IconBox(
              iconData: FontAwesomeIcons.square,
              tooltip: 'Square',
              drawingTool: DrawingTool.square),
          _IconBox(
              iconData: FontAwesomeIcons.circle,
              tooltip: 'Circle',
              drawingTool: DrawingTool.circle),
        ],
      ),
    );
  }

  Widget _buildColorsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: const ColorPalette(),
    );
  }

  Widget _buildSizeSliders() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Row(
              children: [
                _IconBox(
                  tooltip: "Stroke Size",
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 22,
                        height: 2,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                    child: Slider(
                  value: controller.strokeSize.value,
                  min: 1,
                  max: 50,
                  divisions: 5,
                  onChanged: (value) {
                    controller.strokeSize.value = value;
                  },
                  activeColor: AppColors.gradient2,
                  inactiveColor: AppColors.greyColor,
                )),
              ],
            ),
            Row(
              children: [
                _IconBox(
                  iconData: FontAwesomeIcons.eraser,
                  tooltip: "Eraser Size",
                ),
                SizedBox(width: 8.w),
                Expanded(
                    child: Slider(
                  value: controller.eraserSize.value,
                  min: 1,
                  max: 50,
                  divisions: 5,
                  onChanged: (value) {
                    controller.eraserSize.value = value;
                  },
                  activeColor: AppColors.gradient1,
                  inactiveColor: AppColors.greyColor,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: Icons.undo,
            onPressed: () {
              controller.undo();
              controller.update();
            },
            message: "Undo",
          ),
          _ActionButton(
            icon: Icons.redo,
            onPressed: () {
              controller.redo();
              controller.update();
            },
            message: "Redo",
          ),
          _ActionButton(
            icon: Icons.delete_outline,
            onPressed: () {
              controller.clear();
              controller.update();
            },
            message: "Clear",
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorOptions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: const Column(
        children: [
          _IconSetting(
            icon: Icons.calculate,
            label: 'Scientific Mode',
          ),
          _IconSetting(
            icon: Icons.history,
            label: 'History',
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildDrawerSectionTitle('Drawing Tools'),
        _buildDrawingToolsList(),
        SizedBox(height: 10.h),
        const Divider(),
        SizedBox(height: 10.h),
        _buildDrawerSectionTitle('Colors'),
        _buildColorsSection(),
        SizedBox(height: 10.h),
        const Divider(),
        SizedBox(height: 10.h),
        _buildDrawerSectionTitle('Size'),
        _buildSizeSliders(),
        SizedBox(height: 10.h),
        const Divider(),
        SizedBox(height: 10.h),
        _buildDrawerSectionTitle('Actions'),
        _buildActionButtons(),
        SizedBox(height: 10.h),
        const Divider(),
        SizedBox(height: 10.h),
        _buildDrawerSectionTitle('Calculator'),
        _buildCalculatorOptions(),
        const Divider(),
      ],
    );
  }

  Widget _buildCollapsedContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _IconBox(
          iconData: _getIconForSelectedTool(),
          tooltip: _getTooltipForSelectedTool(),
          drawingTool: controller.selectedDrawingTool.value,
        ),
        Tooltip(
            message: "Stroke Color",
            child: ColorCircle(color: controller.selectedColor.value)),
        Tooltip(
          message: "Stroke Size",
          child: Container(
            height: 25.sp,
            width: 25.sp,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.cyanAccent,
                width: 2.0.w,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Center(
              child: Text(
                '${controller.strokeSize.value.toInt()}',
                style: const TextStyle(color: AppColors.whiteColor),
              ),
            ),
          ),
        ),
        Tooltip(
          message: "Eraser Size",
          child: Container(
            height: 25.sp,
            width: 25.sp,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.cyanAccent,
                width: 2.0.w,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Center(
              child: Text(
                '${controller.eraserSize.value.toInt()}',
                style: const TextStyle(color: AppColors.whiteColor),
              ),
            ),
          ),
        ),
        _ActionButton(
          icon: Icons.undo,
          onPressed: controller.undo,
          message: "Undo",
        ),
        _ActionButton(
          icon: Icons.redo,
          onPressed: controller.redo,
          message: "Redo",
        ),
        _ActionButton(
          icon: Icons.delete,
          onPressed: controller.clear,
          message: "Clear",
        ),
      ],
    );
  }

  IconData? _getIconForSelectedTool() {
    switch (controller.selectedDrawingTool.value) {
      case DrawingTool.select:
        return FontAwesomeIcons.arrowPointer;
      case DrawingTool.pencil:
        return FontAwesomeIcons.pencil;
      case DrawingTool.eraser:
        return FontAwesomeIcons.eraser;
      case DrawingTool.line:
        return Icons.line_style;
      case DrawingTool.square:
        return FontAwesomeIcons.square;
      case DrawingTool.circle:
        return FontAwesomeIcons.circle;
      default:
        return null;
    }
  }

  String? _getTooltipForSelectedTool() {
    switch (controller.selectedDrawingTool.value) {
      case DrawingTool.select:
        return 'Select';
      case DrawingTool.pencil:
        return 'Pencil';
      case DrawingTool.eraser:
        return 'Eraser';
      case DrawingTool.line:
        return 'Line';
      case DrawingTool.square:
        return 'Square';
      case DrawingTool.circle:
        return 'Circle';
      default:
        return null;
    }
  }
}

class _IconBox extends StatelessWidget {
  final IconData? iconData;
  final Widget? child;
  final DrawingTool? drawingTool;
  final String? tooltip;
  final controller = Get.find<CalculatorController>();

  _IconBox({
    this.iconData,
    this.drawingTool,
    this.child,
    this.tooltip,
  }) : assert(child != null || iconData != null);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (drawingTool != null) {
              controller.selectedDrawingTool.value = drawingTool!;
              controller.update();
            }
          },
          child: Container(
            height: 35.sp,
            width: 35.sp,
            decoration: BoxDecoration(
              border: Border.all(
                color: controller.selectedDrawingTool.value == drawingTool
                    ? Colors.cyanAccent
                    : Colors.grey,
                width: 2.0.w,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Tooltip(
              message: tooltip,
              preferBelow: false,
              child: child ??
                  Icon(
                    iconData,
                    color: AppColors.greyColor,
                    size: 15.sp,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.message,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: IconButton(
        icon: Icon(icon, color: AppColors.whiteColor),
        iconSize: 30.sp,
        onPressed: onPressed,
      ),
    );
  }
}

class _IconSetting extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconSetting({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.whiteColor),
      title: Text(
        label,
        style: const TextStyle(color: AppColors.whiteColor),
      ),
      onTap: () {},
    );
  }
}
