import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_calculator/core/theme/app_colors.dart';

class EnterPromptWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool isSolve;
  const EnterPromptWidget(
      {super.key, required this.textEditingController, this.isSolve = false});

  @override
  State<EnterPromptWidget> createState() => _EnterPromptWidgetState();
}

class _EnterPromptWidgetState extends State<EnterPromptWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.08.sh,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5.r,
            blurRadius: 7.r,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: widget.textEditingController,
        minLines: 1,
        maxLines: 3,
        autofocus: false,
        cursorColor: AppColors.secondaryColor,
        keyboardType: TextInputType.text,
        style: TextStyle(
            fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),
        decoration: InputDecoration(
          hintText: "How can I help you?",
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(
                widget.isSolve
                    ? Icons.arrow_forward_ios_rounded
                    : Icons.attach_file,
                color: AppColors.greyColor),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
