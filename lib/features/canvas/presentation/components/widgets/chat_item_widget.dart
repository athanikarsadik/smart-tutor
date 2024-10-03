import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:socrita/core/constants/show_snack_bar.dart';
import 'package:socrita/features/canvas/presentation/controllers/home_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:toastification/toastification.dart';

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
                return SvgPicture.asset(
                  "assets/svg/logo_icon.svg",
                  width: 22.sp,
                );
              }
            }),
          SizedBox(
            width: 10.w,
          ),
          for (int i = 0; i < content.parts.length; i++)
            if (content.parts[i] is TextPart)
              _buildTextPart(content.parts[i] as TextPart, isUser, context)
            else if (content.parts[i] is DataPart)
              _buildImagePart(content.parts[i] as DataPart, isUser),
        ],
      ),
    );
  }

  Widget _buildTextPart(TextPart textPart, bool isUser, BuildContext context) {
    final messageText = textPart.text;

    final messageWithEmojis = messageText.replaceAllMapped(
      RegExp(r'\\u([0-9a-fA-F]{4})'),
      (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
    );

    return Container(
      constraints: BoxConstraints(
          maxWidth: isUser
              ? userWidth.sw
              : userWidth == 0.2
                  ? 0.252.sw
                  : 0.47.sw),
      margin: EdgeInsets.symmetric(vertical: 6.w, horizontal: 6.w),
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: isUser
            ? AppColors.canvasChatUserColor
            : AppColors.canvasChatAIColor,
        borderRadius: BorderRadius.only(
            topLeft: isUser ? Radius.circular(20.r) : const Radius.circular(0),
            topRight: isUser ? const Radius.circular(0) : Radius.circular(20.r),
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          isUser
              ? ExpandableTextWidget(text: messageWithEmojis)
              : MarkdownWidget(
                  messageText: messageWithEmojis,
                ),
          if (!isUser)
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  icon: Icon(Icons.copy, size: 18.sp, color: Colors.white70),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: messageWithEmojis));
                    showSnackBar(
                        type: ToastificationType.success,
                        msg: "Message copied to clipboard!");
                  }),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePart(DataPart imageData, bool isUser) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.w, horizontal: 6.w),
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: isUser
            ? AppColors.canvasChatUserColor
            : AppColors.canvasChatAIColor,
        borderRadius: BorderRadius.only(
          topLeft: isUser ? Radius.circular(20.r) : const Radius.circular(0),
          topRight: isUser ? const Radius.circular(0) : Radius.circular(20.r),
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Image.memory(
        imageData.bytes,
        fit: BoxFit.cover,
        height: 200.h,
      ),
    );
  }
}
