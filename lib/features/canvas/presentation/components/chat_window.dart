// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:socrita/features/canvas/presentation/components/widgets/animated_button.dart';
import 'package:socrita/features/canvas/presentation/components/widgets/custom_tool_tip_widget.dart';
import 'package:socrita/features/canvas/presentation/pages/expanded_chat_window.dart';
import 'package:socrita/features/canvas/presentation/controllers/home_controller.dart';

import '../../../../core/constants/asset_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/deepgram_controller.dart';
import 'widgets/chat_dialog_section.dart';
import 'widgets/custom_drop_down.dart';

class ChatWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onChatIconTap;

  ChatWindow({
    super.key,
    required this.onClose,
    required this.onChatIconTap,
  });

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final controller = Get.find<HomeController>();

  final DeepgramController _deepgramController = Get.find<DeepgramController>();

  bool _isListening = false;

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
                          callbackAction: widget.onChatIconTap,
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
                          callbackAction: widget.onChatIconTap,
                          height: 70.h,
                          padding: EdgeInsets.all(15.sp),
                          backgroundColor: !controller.isChatDialog.value
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
                                  onChatIconTap: widget.onChatIconTap,
                                ),
                              );
                            },
                          );
                        },
                        icon: SvgPicture.asset(
                          "assets/svg/expand.svg",
                          height: 20.sp,
                        )),
                  ),
                  CustomTooltip(
                    message: "Hide",
                    child: IconButton(
                        onPressed: widget.onClose,
                        icon: Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: AppColors.whiteColor,
                          size: 30.sp,
                          weight: 2,
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
          Obx(
            () => controller.isChatDialog.value
                ? const ChatDialogSection()
                : Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Obx(() => RawKeyboardListener(
                            focusNode: FocusNode(),
                            onKey: _handleKeyEvent,
                            child: Focus(
                              autofocus: true,
                              child: Container(
                                padding: EdgeInsets.all(20.sp),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _deepgramController.isRecording
                                      ? AppColors.canvasButtonColor
                                      : AppColors.canvasTernaryColor,
                                  border: Border.all(
                                      color: AppColors.canvasBorderColor),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    if (_deepgramController.isRecording) {
                                      _deepgramController.stopListening();
                                    } else {
                                      _deepgramController.startListening();
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    "assets/svg/mic.svg",
                                    colorFilter: ColorFilter.mode(
                                        _deepgramController.isRecording
                                            ? AppColors.whiteColor
                                            : AppColors.canvasDividerColor,
                                        BlendMode.srcIn),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.physicalKey == PhysicalKeyboardKey.space) {
      if (event is RawKeyDownEvent && !_isListening) {
        setState(() => _isListening = true);
        _deepgramController.startListening();
      } else if (event is RawKeyUpEvent && _isListening) {
        setState(() => _isListening = false);
        _deepgramController.stopListening();
      }
    }
  }

  @override
  void dispose() {
    if (_isListening) {
      _deepgramController.stopListening();
    }
    super.dispose();
  }
}
