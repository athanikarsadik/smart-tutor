import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:socratica/core/constants/asset_strings.dart';
import 'package:socratica/features/canvas/presentation/components/widgets/animated_button.dart';
import 'package:socratica/features/canvas/presentation/components/widgets/custom_tool_tip_widget.dart';
import 'package:socratica/features/canvas/presentation/components/widgets/enter_prompt_text_widget.dart';
import 'package:socratica/features/canvas/presentation/pages/expanded_chat_window.dart';
import 'package:socratica/features/home/presentation/controller/home_controller.dart';
import 'package:socratica/features/home/presentation/widgets/result_display_widget.dart';

import '../../../../core/theme/app_colors.dart';
import 'widgets/custom_drop_down.dart';

class ChatWindow extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onChatIconTap;

  ChatWindow({
    super.key,
    required this.onClose,
    required this.onChatIconTap,
  });

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550.w,
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
                          iconPath: AssetStrings.chatSvg),
                      AnimatedIconButton(
                          width: 70.w,
                          message: "Speak",
                          callbackAction: onChatIconTap,
                          height: 70.h,
                          padding: EdgeInsets.all(15.sp),
                          backgroundColor: !controller.isChatDialog.value
                              ? AppColors.canvasSecondaryColor
                              : Colors.transparent,
                          shadowColor: !controller.isChatDialog.value
                              ? AppColors.blackColor.withOpacity(0.25)
                              : Colors.transparent,
                          iconPath: AssetStrings.micSvg),
                    ],
                  ),
                ),
              ),

              // Right options
              Row(
                children: [
                  CustomTooltip(
                    message: "Expand",
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: const EdgeInsets.all(0),
                                child: ExpandedChatWindow(
                                  onChatIconTap: onChatIconTap,
                                ),
                              );
                            },
                          );
                        },
                        icon: SvgPicture.asset(
                          AssetStrings.expandSvg,
                          height: 20.sp,
                        )),
                  ),
                  CustomTooltip(
                    message: "Hide",
                    child: IconButton(
                        onPressed: onClose,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: AppColors.whiteColor,
                        )),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Dropdown options
          Row(
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
          SizedBox(height: 20.h),
          Divider(color: AppColors.canvasDividerColor),
          SizedBox(height: 20.h),
          // Chat dialog section
          Obx(() => controller.isChatDialog.value
              ? Expanded(child: ChatDialogSection())
              : Expanded(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20.sp),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.canvasTernaryColor,
                          border:
                              Border.all(color: AppColors.canvasBorderColor)),
                      child: SvgPicture.asset(
                        AssetStrings.micSvg,
                        colorFilter: const ColorFilter.mode(
                            AppColors.canvasButtonColor, BlendMode.srcIn),
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}

class ChatDialogSection extends StatelessWidget {
  const ChatDialogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Expanded(child: ResultsDisplay()),
          SizedBox(height: 10.h),
          Obx(() => Get.find<HomeController>().isStreaming.value
              ? Lottie.asset(
                  'assets/lottie/ai.json',
                  width: 100.w,
                  height: 100.h,
                )
              : const EnterPromptTextWidget()),
        ],
      ),
    );
  }
}
