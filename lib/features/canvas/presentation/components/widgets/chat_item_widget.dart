import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:socratica/features/canvas/presentation/controllers/home_controller.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/theme/app_colors.dart';
import 'expandable_text_widget.dart';
import 'markdown_widget.dart';

class ChatItemWidget extends StatelessWidget {
  final Content content;
  final double userWidth;

  const ChatItemWidget(
      {super.key, required this.content, this.userWidth = 0.25});

  @override
  Widget build(BuildContext context) {
    final bool isUser = content.role == "user";
    final String messageText = content.parts.last is TextPart
        ? (content.parts.last as TextPart).text
        : 'Cannot generate data!';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Obx(() {
              final isStreaming = Get.find<HomeController>().isStreaming.value;
              if (isStreaming) {
                return Lottie.asset(
                  'assets/lottie/streaming.json',
                  width: 20.w,
                  height: 20.h,
                );
              } else {
                return Icon(Icons.smart_toy, size: 20.sp, color: Colors.white);
              }
            }),
          SizedBox(
            width: 10.w,
          ),
          Container(
            constraints: BoxConstraints(
                maxWidth: isUser
                    ? userWidth.sw
                    : userWidth == 0.2
                        ? 0.252.sw
                        : 0.47.sw),
            margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: isUser
                  ? AppColors.canvasChatUserColor
                  : AppColors.canvasChatAIColor,
              borderRadius: BorderRadius.only(
                  topLeft:
                      isUser ? Radius.circular(20.r) : const Radius.circular(0),
                  topRight:
                      isUser ? const Radius.circular(0) : Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                isUser
                    ? ExpandableTextWidget(text: messageText)
                    : MarkdownWidget(
                        messageText: messageText,
                      ),
                if (!isUser)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon:
                          Icon(Icons.copy, size: 18.sp, color: Colors.white70),
                      onPressed: () {
                        // Implement copy functionality
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
