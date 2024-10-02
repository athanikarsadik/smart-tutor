import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socratica/features/canvas/domain/entities/drawing_tool_entity.dart';
import 'package:socratica/features/canvas/presentation/components/widgets/color_drop_down.dart';
import 'package:socratica/features/canvas/presentation/components/widgets/custom_tool_tip_widget.dart';

// import '../../../../core/constants/asset_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/home_controller.dart';
import 'widgets/icon_widget.dart';

class FloatingOptionBar extends StatelessWidget {
  final _controller = Get.find<HomeController>();
  FloatingOptionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.sp,
      width: 500.sp,
      // margin: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppColors.canvasSecondaryColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: AppColors.blackColor.withOpacity(0.25),
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
          BoxShadow(
            blurRadius: 5,
            color: AppColors.boxShadowColor.withOpacity(0.25),
            offset: const Offset(5, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomTooltip(
              message: _controller.currentSelectOption.value.getName(),
              child: IconWidget(
                assetName: _controller.currentSelectOption.value.getAsset(),
                height: 22.sp,
                isOption: false,
                message: "Move tools",
                mainDrawingTool: MainDrawingTool.selectOptions,
              ),
            ),
            CustomTooltip(
              message: _controller.currentShapeOption.value.getName(),
              child: IconWidget(
                assetName: _controller.currentShapeOption.value.getAsset(),
                height: 22.sp,
                isOption: true,
                message: "Shape tools",
                mainDrawingTool: MainDrawingTool.shapeOptions,
              ),
            ),
            CustomTooltip(
              message: _controller.currentDrawToolOption.value.getName(),
              child: IconWidget(
                assetName: _controller.currentDrawToolOption.value.getAsset(),
                height: 22.sp,
                isOption: true,
                message: "Creation tools",
                mainDrawingTool: MainDrawingTool.drawToolOptions,
              ),
            ),
            CustomTooltip(
              message: "Text",
              child: IconWidget(
                assetName: "assets/svg/text.svg",
                height: 22.sp,
                message: "Text",
                mainDrawingTool: MainDrawingTool.text,
              ),
            ),
            // CustomTooltip(
            //   message: "Add page",
            //   child: IconWidget(
            //     assetName: "assets/svg/add_page.svg",
            //     height: 22.sp,
            //     message: "Add Page",
            //   ),
            // ),
            CustomTooltip(
              message: "Color",
              child: Obx(
                () => HorizontalColorDropdown(
                    selectedValue: _controller.selectedColor.value,
                    onChanged: (val) {
                      _controller.changeColor(val);
                    },
                    colors: _controller.colorList),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
