import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/home_controller.dart';
import 'enter_prompt_text_widget.dart';
import 'result_display_widget.dart';

class ChatDialogSection extends StatelessWidget {
  final double userWidth;
  const ChatDialogSection({super.key, this.userWidth = 0.20});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
              child: ResultsDisplay(
            userWidth: userWidth,
          )),
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
