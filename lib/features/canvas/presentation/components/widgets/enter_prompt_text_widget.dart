import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:socratica/core/constants/asset_strings.dart';
import 'package:socratica/core/theme/app_colors.dart';
import 'package:socratica/features/canvas/presentation/components/widgets/custom_tool_tip_widget.dart';
import 'package:socratica/features/home/presentation/controller/home_controller.dart';

class EnterPromptTextWidget extends StatefulWidget {
  final int minFlex;
  const EnterPromptTextWidget({super.key, this.minFlex = 2});

  @override
  State<EnterPromptTextWidget> createState() => _EnterPromptTextWidgetState();
}

class _EnterPromptTextWidgetState extends State<EnterPromptTextWidget> {
  final promptController = TextEditingController();
  Uint8List? captureCanvasImage;

  @override
  void dispose() {
    super.dispose();
    promptController.dispose();
  }

  void _captureCanvasImage() async {
    final capturedImage = await Get.find<HomeController>().captureCanvasImage();
    setState(() {
      captureCanvasImage = capturedImage;
    });
  }

  void _removeSelectedImage() {
    setState(() {
      captureCanvasImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (captureCanvasImage != null)
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10.h),
                height: 100.h,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.canvasBorderColor),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.memory(
                    captureCanvasImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.whiteColor),
                onPressed: _removeSelectedImage,
              ),
            ],
          ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 70.h, maxHeight: 120.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 11,
                child: TextField(
                  controller: promptController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  cursorColor: AppColors.canvasButtonColor,
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: null,
                  minLines: 1,
                  decoration: InputDecoration(
                    suffixIcon: CustomTooltip(
                      message: "Add canvas image",
                      child: IconButton(
                        onPressed: _captureCanvasImage,
                        icon: SvgPicture.asset(
                          AssetStrings.addImageSvg,
                          height: 25.sp,
                        ),
                      ),
                    ),
                    hintText: "What's in your mind?",
                    hintStyle: TextStyle(
                        color: AppColors.whiteColor.withOpacity(0.5),
                        fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(
                        color: AppColors.canvasButtonColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(
                        color: AppColors.canvasBorderColor,
                        width: 0.6,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: widget.minFlex,
                child: InkWell(
                  onTap: () {
                    var prompt = promptController.text.trim();
                    if (prompt.isNotEmpty) {
                      Get.find<HomeController>()
                          .getResponse(prompt, captureCanvasImage);
                    }
                    _removeSelectedImage();
                    promptController.clear();
                  },
                  child: Container(
                      height: 70.h,
                      padding: EdgeInsets.all(12.sp),
                      decoration: BoxDecoration(
                        color: promptController.text.trim().isEmpty
                            ? AppColors.canvasSecondaryColor
                            : AppColors.canvasButtonColor,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                            width: 0.6,
                            color: promptController.text.trim().isEmpty
                                ? AppColors.canvasBorderColor
                                : Colors.transparent),
                      ),
                      child: SvgPicture.asset(
                        AssetStrings.sendSvg,
                        height: 25.sp,
                        colorFilter: ColorFilter.mode(
                            promptController.text.trim().isNotEmpty
                                ? AppColors.whiteColor
                                : AppColors.canvasButtonColor,
                            BlendMode.srcIn),
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
