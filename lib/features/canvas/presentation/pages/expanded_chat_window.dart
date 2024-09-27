import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:socratica/core/constants/asset_strings.dart';
import 'package:socratica/features/canvas/presentation/components/widgets/animated_button.dart';
import 'package:socratica/features/canvas/presentation/components/widgets/enter_prompt_text_widget.dart';
import 'package:socratica/features/home/presentation/controller/home_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../components/widgets/blurred_background_widget.dart';
import '../components/widgets/custom_drop_down.dart';

class ExpandedChatWindow extends StatelessWidget {
  final VoidCallback onChatIconTap;

  ExpandedChatWindow({super.key, required this.onChatIconTap});

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: BlurredBackground(
            child: Container(
              width: 985.w,
              height: 942.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
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
                      color: AppColors.blackColor.withOpacity(0.25),
                      offset: const Offset(5, 0),
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
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedIconButton(
                                message: "Chat",
                                width: 60.w,
                                callbackAction: onChatIconTap,
                                height: 60.h,
                                padding: EdgeInsets.all(15.sp),
                                backgroundColor: Get.find<HomeController>()
                                        .isChatDialog
                                        .value
                                    ? AppColors.canvasSecondaryColor
                                    : Colors.transparent,
                                shadowColor: Get.find<HomeController>()
                                        .isChatDialog
                                        .value
                                    ? AppColors.blackColor.withOpacity(0.25)
                                    : Colors.transparent,
                                iconPath: AssetStrings.chatSvg),
                            AnimatedIconButton(
                                message: "Speak",
                                width: 70.w,
                                callbackAction: onChatIconTap,
                                height: 70.h,
                                padding: EdgeInsets.all(15.sp),
                                backgroundColor: !Get.find<HomeController>()
                                        .isChatDialog
                                        .value
                                    ? AppColors.canvasSecondaryColor
                                    : Colors.transparent,
                                shadowColor: !Get.find<HomeController>()
                                        .isChatDialog
                                        .value
                                    ? AppColors.blackColor.withOpacity(0.25)
                                    : Colors.transparent,
                                iconPath: AssetStrings.micSvg),
                          ],
                        ),
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
                        width: 985.w,
                        child: const Divider(
                          color: AppColors.canvasDividerColor,
                        ),
                      )),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: SvgPicture.asset(
                          AssetStrings.contractSvg,
                          height: 20.sp,
                        )),
                  ),
                  Obx(
                    () => Get.find<HomeController>().isChatDialog.value
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: const EnterPromptTextWidget(
                                  minFlex: 1,
                                )))
                        : Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.all(20.sp),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.canvasTernaryColor,
                                  border: Border.all(
                                      color: AppColors.canvasBorderColor)),
                              child: SvgPicture.asset(
                                AssetStrings.micSvg,
                                colorFilter: const ColorFilter.mode(
                                    AppColors.canvasButtonColor,
                                    BlendMode.srcIn),
                              ),
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
