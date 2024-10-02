import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socrita/core/theme/app_colors.dart';
import 'package:markdown/markdown.dart' as md;

class MarkdownWidget extends StatelessWidget {
  final String messageText;

  const MarkdownWidget({super.key, required this.messageText});

  @override
  Widget build(BuildContext context) {
    return Markdown(
      padding: EdgeInsets.all(8.0.sp),
      shrinkWrap: true,
      softLineBreak: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          p: TextStyle(
            color: Colors.white,
            fontSize: 18.0.sp,
            fontWeight: FontWeight.w400,
          ),
          codeblockPadding:
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          code: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18.0.sp,
              height: 2,
              fontWeight: FontWeight.w400,
              background: Paint()..color = Colors.transparent),
          h1: TextStyle(
            color: Colors.white,
            fontSize: 24.0.sp,
            fontWeight: FontWeight.bold,
          ),
          h2: TextStyle(
            color: Colors.white,
            fontSize: 22.0.sp,
            fontWeight: FontWeight.bold,
          ),
          h3: TextStyle(
            color: Colors.white,
            fontSize: 20.0.sp,
            fontWeight: FontWeight.bold,
          ),
          h4: TextStyle(
            color: Colors.white,
            fontSize: 20.0.sp,
            fontWeight: FontWeight.bold,
          ),
          blockquote: TextStyle(
            color: Colors.grey.withOpacity(0.2),
          ),
          codeblockDecoration: BoxDecoration(
            color: AppColors.canvasSecondaryColor,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: AppColors.canvasBorderColor,
              width: 1.0,
            ),
          ),
          listBullet: TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp),
          listIndent: 30.w,
          listBulletPadding:
              EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
          codeblockAlign: WrapAlignment.center,
          blockquotePadding: EdgeInsets.all(10.0.sp),
          blockquoteDecoration: BoxDecoration(
              border:
                  Border.all(color: AppColors.backgroundColor, width: 0.5))),
      selectable: true,
      physics: const NeverScrollableScrollPhysics(),
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        <md.InlineSyntax>[
          md.EmojiSyntax(),
          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
        ],
      ),
      data: messageText,
    );
  }
}
