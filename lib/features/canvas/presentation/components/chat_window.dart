import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:socratica/core/constants/asset_strings.dart';
import 'package:socratica/features/canvas/presentation/components/widgets/animated_button.dart';
import 'package:socratica/features/canvas/presentation/components/widgets/enter_prompt_text_widget.dart';
import 'package:socratica/features/home/presentation/controller/home_controller.dart';

import '../../../../core/theme/app_colors.dart';
import 'widgets/custom_drop_down.dart';

class ChatWindow extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onChatIconTap;
  final bool isChat;

  ChatWindow(
      {super.key,
      required this.onClose,
      required this.isChat,
      required this.onChatIconTap});

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550.w,
      height: 942.h,
      margin: EdgeInsets.all(10.sp),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      decoration: BoxDecoration(
          color: AppColors.canvasSecondaryColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: AppColors.blackColor.withOpacity(0.25),
              offset: Offset(0, 5),
              spreadRadius: 0,
            ),
            BoxShadow(
              blurRadius: 5,
              color: AppColors.blackColor.withOpacity(0.25),
              offset: Offset(5, 0),
              spreadRadius: 0,
            ),
          ]),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 60.h,
              width: 150.w,
              padding: EdgeInsets.all(2.sp),
              decoration: BoxDecoration(
                  color: AppColors.canvasTernaryColor,
                  borderRadius: BorderRadius.circular(12.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedIconButton(
                      width: 60.w,
                      callbackAction: onChatIconTap,
                      height: 60.h,
                      padding: EdgeInsets.all(15.sp),
                      backgroundColor: isChat
                          ? AppColors.canvasSecondaryColor
                          : Colors.transparent,
                      shadowColor: isChat
                          ? AppColors.blackColor.withOpacity(0.25)
                          : Colors.transparent,
                      iconPath: AssetStrings.chatSvg),
                  AnimatedIconButton(
                      width: 70.w,
                      callbackAction: onChatIconTap,
                      height: 70.h,
                      padding: EdgeInsets.all(15.sp),
                      backgroundColor: !isChat
                          ? AppColors.canvasSecondaryColor
                          : Colors.transparent,
                      shadowColor: !isChat
                          ? AppColors.blackColor.withOpacity(0.25)
                          : Colors.transparent,
                      iconPath: AssetStrings.micSvg),
                ],
              ),
            ),
          ),
          Positioned(
              top: 100.h,
              child: Obx(
                () => Row(
                  children: [
                    CustomDropdownButton(
                      selectedValue: controller.selectedAIModel.value,
                      items: [controller.aiModels],
                      onChanged: (newValue) {
                        if (newValue != null) {
                          controller.selectedAIModel.value = newValue;
                        }
                      },
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    CustomDropdownButton(
                      selectedValue: controller.selectedAIVoice.value,
                      items: [controller.aiVoices],
                      onChanged: (newValue) {
                        if (newValue != null) {
                          controller.selectedAIVoice.value = newValue;
                        }
                      },
                    ),
                  ],
                ),
              )),
          Positioned(
              top: 180.h,
              left: 0,
              child: SizedBox(
                width: 500.w,
                child: const Divider(
                  color: AppColors.canvasDividerColor,
                ),
              )),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: onClose,
                icon: const Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: AppColors.whiteColor,
                )),
          ),
          isChat
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: const EnterPromptTextWidget()))
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(20.sp),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.canvasTernaryColor,
                        border: Border.all(color: AppColors.canvasBorderColor)),
                    child: SvgPicture.asset(
                      AssetStrings.micSvg,
                      colorFilter: const ColorFilter.mode(
                          AppColors.canvasButtonColor, BlendMode.srcIn),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
