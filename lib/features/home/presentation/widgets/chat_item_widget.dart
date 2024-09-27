import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:socratica/features/home/presentation/controller/home_controller.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/app_colors.dart';

class ChatItemWidget extends StatelessWidget {
  final Content content;

  const ChatItemWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final bool isUser = content.role == "user";
    final String messageText = content.parts.last is TextPart
        ? (content.parts.last as TextPart).text
        : 'Cannot generate data!';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: isUser ? 0.17.sw : 0.7.sw),
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
        padding: EdgeInsets.all(12.sp),
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
            if (!isUser)
              Obx(() {
                final isStreaming =
                    Get.find<HomeController>().isStreaming.value;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isStreaming)
                      Lottie.asset(
                        'assets/lottie/streaming.json',
                        width: 20.w,
                        height: 20.h,
                      )
                    else
                      Icon(Icons.smart_toy, size: 20.sp, color: Colors.white),
                    SizedBox(width: 8.w),
                    const Text(
                      "AI",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              }),
            if (isUser)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, size: 20.sp, color: Colors.white),
                  SizedBox(width: 8.w),
                  const Text(
                    "You",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 8.h),
            isUser
                ? Text(
                    messageText,
                    style: const TextStyle(color: Colors.white),
                  )
                : Markdown(
                    shrinkWrap: true,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                      p: const TextStyle(color: Colors.white),
                      code: TextStyle(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        color: Colors.white,
                      ),
                    ),
                    selectable: true,
                    physics: const NeverScrollableScrollPhysics(),
                    data: messageText,
                  ),
            if (!isUser)
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(Icons.copy, size: 18.sp, color: Colors.white70),
                  onPressed: () {
                    // Implement copy functionality
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
