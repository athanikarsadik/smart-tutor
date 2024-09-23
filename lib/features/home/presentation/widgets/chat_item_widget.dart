import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:socratica/features/home/presentation/controller/home_controller.dart';

import '../../../../core/theme/app_colors.dart';
import 'expandable_text_widget.dart';
import 'package:lottie/lottie.dart';

class ChatItemWidget extends StatelessWidget {
  final Content content;

  const ChatItemWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        content.role == "user"
            ? content.parts.last is TextPart
                ? Padding(
                    padding: EdgeInsets.only(bottom: 5.h, top: 5.h),
                    child: Row(
                      children: [
                        Container(
                          width: 50.w,
                          height: 35.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColors.homescreenBgColor),
                          child: const Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                            child: Container(
                                padding: EdgeInsets.all(10.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: const Color(0xFF7176ED)),
                                child: ExpandableTextWidget(
                                  text: content.parts.last is TextPart
                                      ? (content.parts.last as TextPart).text
                                      : 'Cannot generate data!',
                                ))),
                      ],
                    ),
                  )
                : const SizedBox.shrink()
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Obx(
                      () => Padding(
                        padding: EdgeInsets.only(left: 5.w, top: 15.h),
                        child: Get.find<HomeController>().isStreaming.value
                            ? Lottie.asset('assets/lottie/streaming.json',
                                width: 25.w, height: 25.h)
                            : Icon(Icons.copy_all_outlined, size: 25.sp),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
                      child: Markdown(
                        shrinkWrap: true,
                        styleSheet:
                            MarkdownStyleSheet.fromTheme(Theme.of(context))
                                .copyWith(
                          p: const TextStyle(
                              color: Colors.black), // Set text color to black
                        ),
                        selectable: true,
                        softLineBreak: true,
                        physics: const NeverScrollableScrollPhysics(),
                        data: content.parts.last is TextPart
                            ? (content.parts.last as TextPart).text
                            : 'Cannot generate data!',
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
