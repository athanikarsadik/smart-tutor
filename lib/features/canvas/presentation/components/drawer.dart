import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socratica/core/constants/asset_strings.dart';
import 'package:socratica/features/canvas/presentation/components/widgets/drawer_option_row_widget.dart';

import '../../../../core/theme/app_colors.dart';
import 'widgets/color_selection_widget.dart';

class AnimatedDrawer extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onToggle;

  const AnimatedDrawer(
      {super.key, required this.isOpen, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          blurRadius: 4,
          color: AppColors.blackColor.withOpacity(0.25),
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          blurRadius: 4,
          color: AppColors.blackColor.withOpacity(0.25),
          offset: Offset(4, 0),
          spreadRadius: 0,
        ),
      ]),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      child: isOpen
          ? Container(
              height: 420.h,
              width: 440.w,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              decoration: BoxDecoration(
                  color: AppColors.canvasSecondaryColor,
                  borderRadius: BorderRadius.circular(10.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const DrawerOptionRowWidget(
                    leadingAsset: AssetStrings.fileSvg,
                    title: "Open",
                    hint: "Ctrl+O",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const DrawerOptionRowWidget(
                    leadingAsset: AssetStrings.downloadSvg,
                    title: "Save to..",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const DrawerOptionRowWidget(
                    leadingAsset: AssetStrings.exportSvg,
                    title: "Export Image",
                    hint: "Ctrl+Shift+E",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const DrawerOptionRowWidget(
                    leadingAsset: AssetStrings.resetSvg,
                    title: "Reset the canvas",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Divider(
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
                      colors: [
                        Colors.grey[800]!,
                        Colors.grey[900]!,
                        Colors.indigo[900]!,
                        Colors.blueGrey[900]!,
                        Colors.green[900]!,
                        Colors.brown[900]!,
                        Colors.white,
                      ],
                      onColorSelected: (color) {
                        print('Selected color: $color');
                      },
                    ),
                  )
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
