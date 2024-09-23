import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socratica/core/constants/asset_strings.dart';
import 'package:socratica/core/theme/app_colors.dart';

class EnterPromptTextWidget extends StatefulWidget {
  const EnterPromptTextWidget({super.key});

  @override
  State<EnterPromptTextWidget> createState() => _EnterPromptTextWidgetState();
}

class _EnterPromptTextWidgetState extends State<EnterPromptTextWidget> {
  final promptController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    promptController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
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
            flex: 2,
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
        ],
      ),
    );
  }
}
