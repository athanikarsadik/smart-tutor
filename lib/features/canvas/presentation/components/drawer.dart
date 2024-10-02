import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:socrita/core/constants/asset_strings.dart';
import 'package:socrita/features/canvas/presentation/components/widgets/drawer_option_row_widget.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/home_controller.dart';
import 'widgets/color_selection_widget.dart';

// ignore: must_be_immutable
class AnimatedDrawer extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onToggle;

  bool Function(KeyEvent)? _keyboardHandler;
  AnimatedDrawer({super.key, required this.isOpen, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final FocusNode drawerFocusNode = FocusNode();

    if (isOpen) {
      drawerFocusNode.requestFocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _addKeyboardShortcutListener(context);
      });
    } else {
      drawerFocusNode.unfocus();
      _removeKeyboardShortcutListener();
    }

    return KeyboardListener(
      focusNode: drawerFocusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (HardwareKeyboard.instance.isControlPressed &&
              HardwareKeyboard.instance.isShiftPressed &&
              event.logicalKey == LogicalKeyboardKey.keyE) {
            Get.find<HomeController>().importImage();
          }
          if (HardwareKeyboard.instance.isControlPressed &&
              HardwareKeyboard.instance.isShiftPressed &&
              event.logicalKey == LogicalKeyboardKey.keyS) {
            Get.find<HomeController>().exportImage();
          }
        }
      },
      child: AnimatedContainer(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: AppColors.blackColor.withOpacity(0.25),
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            blurRadius: 4,
            color: AppColors.blackColor.withOpacity(0.25),
            offset: const Offset(4, 0),
            spreadRadius: 0,
          ),
        ]),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        child: isOpen
            ? Container(
                height: 600.h,
                width: 440.w,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                decoration: BoxDecoration(
                    color: AppColors.canvasSecondaryColor,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Material(
                    //   color: Colors.transparent,
                    //   animationDuration: const Duration(milliseconds: 400),
                    //   borderRadius: BorderRadius.circular(10.r),
                    //   child: InkWell(
                    //     onTap: () {},
                    //     child: const DrawerOptionRowWidget(
                    //       leadingAsset: "assets/svg/file.svg",
                    //       title: "Open",
                    //       hint: "Ctrl+O",
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 20.h,
                    // ),
                    Obx(
                      () => Material(
                        color: Colors.transparent,
                        animationDuration: const Duration(milliseconds: 400),
                        borderRadius: BorderRadius.circular(10.r),
                        child: InkWell(
                          onTap: () {
                            Get.find<HomeController>().exportImage();
                          },
                          child: DrawerOptionRowWidget(
                            leadingAsset: "assets/svg/download.svg",
                            title: "Export Image",
                            hint: "Ctrl+Shift+S",
                            isLoading:
                                Get.find<HomeController>().isDownload.value,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Material(
                      color: Colors.transparent,
                      animationDuration: const Duration(milliseconds: 400),
                      borderRadius: BorderRadius.circular(15.r),
                      child: InkWell(
                        onTap: () async {
                          await Get.find<HomeController>().importImage();
                        },
                        child: const DrawerOptionRowWidget(
                          leadingAsset: "assets/svg/export_png.svg",
                          title: "Import Image",
                          hint: "Ctrl+Shift+E",
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 20.h,
                    // ),
                    // Material(
                    //   color: Colors.transparent,
                    //   animationDuration: const Duration(milliseconds: 400),
                    //   borderRadius: BorderRadius.circular(10.r),
                    //   child: InkWell(
                    //     onTap: () {
                    //       Get.find<HomeController>().clear();
                    //     },
                    //     child: const DrawerOptionRowWidget(
                    //       leadingAsset: "assets/svg/reset.svg",
                    //       title: "Reset the canvas",
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const Divider(
                      color: AppColors.canvasDividerColor,
                    ),
                    Text(
                      "Font Size",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.whiteColor),
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            "${Get.find<HomeController>().fontSize.value.toInt()}",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.canvasStrokeBgColor),
                          ),
                          Expanded(
                            child: Slider(
                              value: Get.find<HomeController>().fontSize.value,
                              min: 1,
                              max: 48,
                              divisions: 48,
                              onChanged: (value) {
                                Get.find<HomeController>().fontSize.value =
                                    value;
                              },
                              activeColor: AppColors.canvasButtonColor,
                              inactiveColor: AppColors.canvasStrokeBgColor,
                            ),
                          ),
                          Text(
                            "48",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.canvasStrokeBgColor),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Stroke",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.whiteColor),
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            "${Get.find<HomeController>().strokeSize.value.toInt()}",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.canvasStrokeBgColor),
                          ),
                          Expanded(
                            child: Slider(
                              value:
                                  Get.find<HomeController>().strokeSize.value,
                              min: 1,
                              max: 48,
                              divisions: 48,
                              onChanged: (value) {
                                Get.find<HomeController>().strokeSize.value =
                                    value;
                              },
                              activeColor: AppColors.canvasButtonColor,
                              inactiveColor: AppColors.canvasStrokeBgColor,
                            ),
                          ),
                          Text(
                            "50",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.canvasStrokeBgColor),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: AppColors.canvasDividerColor,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Canvas background",
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.canvasTextColor),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Flexible(
                      child: AnimatedColorPalette(
                        colors: Get.find<HomeController>().backgroundColors,
                        onColorSelected: (color) {
                          Get.find<HomeController>().selectedBgColor.value =
                              color;
                          Get.find<HomeController>().update();
                        },
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  void _addKeyboardShortcutListener(BuildContext context) {
    // Create the handler function
    _keyboardHandler = (KeyEvent event) {
      if (event is KeyDownEvent) {
        if (HardwareKeyboard.instance.logicalKeysPressed
                .contains(LogicalKeyboardKey.control) &&
            HardwareKeyboard.instance.logicalKeysPressed
                .contains(LogicalKeyboardKey.shift) &&
            event.logicalKey == LogicalKeyboardKey.keyE) {
          Get.find<HomeController>().importImage();
          return true;
        }
        if (HardwareKeyboard.instance.logicalKeysPressed
                .contains(LogicalKeyboardKey.control) &&
            HardwareKeyboard.instance.logicalKeysPressed
                .contains(LogicalKeyboardKey.shift) &&
            event.logicalKey == LogicalKeyboardKey.keyS) {
          Get.find<HomeController>().exportImage();
          return true;
        }
      }
      return false;
    };

    HardwareKeyboard.instance.addHandler(_keyboardHandler!);
  }

  void _removeKeyboardShortcutListener() {
    if (_keyboardHandler != null) {
      HardwareKeyboard.instance.removeHandler(_keyboardHandler!);
      _keyboardHandler = null;
    }
  }
}
