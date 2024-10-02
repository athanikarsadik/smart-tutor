import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:socrita/core/constants/asset_strings.dart';
import 'package:socrita/features/canvas/presentation/components/widgets/animated_button.dart';
import 'package:socrita/features/canvas/presentation/controllers/home_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../components/widgets/blurred_background_widget.dart';
import '../components/widgets/chat_dialog_section.dart';
import '../components/widgets/custom_drop_down.dart';
import '../components/widgets/custom_tool_tip_widget.dart';

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
              child: Column(
                children: [
                  // Top section with options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left options
                      Container(
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
                                  width: 60.w,
                                  message: "Chat",
                                  callbackAction: onChatIconTap,
                                  height: 60.h,
                                  padding: EdgeInsets.all(15.sp),
                                  backgroundColor: controller.isChatDialog.value
                                      ? AppColors.canvasSecondaryColor
                                      : Colors.transparent,
                                  shadowColor: controller.isChatDialog.value
                                      ? AppColors.blackColor.withOpacity(0.25)
                                      : Colors.transparent,
                                  iconPath: "assets/svg/chat.svg"),
                              AnimatedIconButton(
                                  width: 70.w,
                                  message: "Speak",
                                  callbackAction: onChatIconTap,
                                  height: 70.h,
                                  padding: EdgeInsets.all(15.sp),
                                  backgroundColor:
                                      !controller.isChatDialog.value
                                          ? AppColors.canvasSecondaryColor
                                          : Colors.transparent,
                                  shadowColor: !controller.isChatDialog.value
                                      ? AppColors.blackColor.withOpacity(0.25)
                                      : Colors.transparent,
                                  iconPath: "assets/svg/mic.svg"),
                            ],
                          ),
                        ),
                      ),

                      // Right options
                      Row(
                        children: [
                          CustomTooltip(
                            message: "Contract",
                            child: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: SvgPicture.asset(
                                  "assets/svg/contract.svg",
                                  height: 20.sp,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Dropdown options
                  Obx(
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
                        SizedBox(width: 10.w),
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
                  ),
                  SizedBox(height: 20.h),
                  const Divider(color: AppColors.canvasDividerColor),
                  SizedBox(height: 20.h),
                  // Chat dialog section
                  Obx(() => controller.isChatDialog.value
                      ? const ChatDialogSection(
                          userWidth: 0.40,
                        )
                      : Expanded(
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(20.sp),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.canvasTernaryColor,
                                  border: Border.all(
                                      color: AppColors.canvasBorderColor)),
                              child: SvgPicture.asset(
                                "assets/svg/mic.svg",
                                colorFilter: const ColorFilter.mode(
                                    AppColors.canvasButtonColor,
                                    BlendMode.srcIn),
                              ),
                            ),
                          ),
                        )),
                ],
              ),
            ),
          ),
        ));
  }
}
