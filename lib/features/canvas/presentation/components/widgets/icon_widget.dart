import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:socratica/core/extensions/drawing_tool_extension.dart';
import 'package:socratica/core/theme/app_colors.dart';
import 'package:socratica/features/canvas/presentation/components/widgets/custom_drop_down.dart';
import 'package:socratica/features/canvas/presentation/controllers/home_controller.dart';

import '../../../../../core/extensions/drawing_tool_extension.dart';
import '../../../domain/entities/drawing_tool_entity.dart';

class IconWidget extends StatelessWidget {
  final String assetName;
  final ColorFilter? colorFilter;
  final double? height;
  final String message;
  final MainDrawingTool? mainDrawingTool;
  final bool isOption;
  IconWidget(
      {super.key,
      required this.assetName,
      required this.message,
      this.mainDrawingTool,
      this.colorFilter,
      this.height,
      this.isOption = false});

  final _controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Container(
            height: 45.sp,
            width: 45.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: _controller.mainSelectedTool.value == mainDrawingTool
                  ? AppColors.canvasButtonColor
                  : null,
            ),
            child: IconButton(
              iconSize: height,
              style: ButtonStyle(
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              icon: SvgPicture.asset(
                assetName,
                colorFilter: colorFilter,
                height: height,
                width: height,
              ),
              onPressed: () {
                switch (message) {
                  case "Move tools":
                    _controller.mainSelectedTool.value =
                        MainDrawingTool.selectOptions;
                    _controller.selectedDrawingTool.value =
                        DrawingToolExtension.fromName(
                            _controller.currentSelectOption.value.getName());
                    _controller.update();
                    break;
                  case "Shape tools":
                    _controller.mainSelectedTool.value =
                        MainDrawingTool.shapeOptions;
                    _controller.selectedDrawingTool.value =
                        DrawingToolExtension.fromName(
                            _controller.currentShapeOption.value.getName());
                    _controller.update();
                    break;
                  case "Creation tools":
                    _controller.mainSelectedTool.value =
                        MainDrawingTool.drawToolOptions;
                    _controller.selectedDrawingTool.value =
                        DrawingToolExtension.fromName(
                            _controller.currentDrawToolOption.value.getName());
                    _controller.update();
                    break;
                  case "Text":
                    _controller.mainSelectedTool.value = MainDrawingTool.text;
                    _controller.selectedDrawingTool.value =
                        DrawingToolExtension.fromName(
                            _controller.mainSelectedTool.value.getName());
                    _controller.update();
                    break;
                }
              },
            ),
          ),
          isOption
              ? Tooltip(
                  textStyle: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp),
                  decoration: BoxDecoration(
                      color: AppColors.canvasButtonColor,
                      borderRadius: BorderRadius.circular(10.r)),
                  preferBelow: false,
                  message: message,
                  child: message == "Move tools"
                      ? CustomDropdownButton(
                          paddingHor: 2.w,
                          selectedValue:
                              _controller.currentSelectOption.value.getName(),
                          items: [
                            _controller.currentSelectOption.value
                                .getOptionsList(),
                            _controller.currentSelectOption.value
                                .getAssetsList()
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              _controller.currentSelectOption.value =
                                  SelectOptionsExtension.fromName(val);
                              _controller.mainSelectedTool.value =
                                  MainDrawingTool.selectOptions;
                              _controller.selectedDrawingTool.value =
                                  DrawingToolExtension.fromName(val);
                              _controller.update();
                            }
                          },
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20.sp,
                          ))
                      : message == "Shape tools"
                          ? CustomDropdownButton(
                              paddingHor: 2.w,
                              selectedValue: _controller
                                  .currentShapeOption.value
                                  .getName(),
                              items: [
                                _controller.currentShapeOption.value
                                    .getOptionsList(),
                                _controller.currentShapeOption.value
                                    .getAssetsList()
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  _controller.currentShapeOption.value =
                                      ShapeOptionsExtension.fromName(val);
                                  _controller.mainSelectedTool.value =
                                      MainDrawingTool.shapeOptions;
                                  _controller.selectedDrawingTool.value =
                                      DrawingToolExtension.fromName(val);
                                  _controller.update();
                                }
                              },
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20.sp,
                              ),
                            )
                          : message == "Creation tools"
                              ? CustomDropdownButton(
                                  paddingHor: 2.w,
                                  selectedValue: _controller
                                      .currentDrawToolOption.value
                                      .getName(),
                                  items: [
                                    _controller.currentDrawToolOption.value
                                        .getOptionsList(),
                                    _controller.currentDrawToolOption.value
                                        .getAssetsList()
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      _controller.currentDrawToolOption.value =
                                          DrawToolOptionsExtension.fromName(
                                              val);
                                      _controller.mainSelectedTool.value =
                                          MainDrawingTool.drawToolOptions;
                                      _controller.selectedDrawingTool.value =
                                          DrawingToolExtension.fromName(val);
                                      _controller.update();
                                    }
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 20.sp,
                                  ),
                                )
                              : const SizedBox.shrink())
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
