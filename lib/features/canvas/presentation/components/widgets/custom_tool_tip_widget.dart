import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final Duration showDuration;
  final Duration hideDuration;
  final Duration waitDuration;
  final bool preferBelow;

  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.showDuration = const Duration(milliseconds: 500), 
    this.hideDuration = const Duration(milliseconds: 200), 
    this.waitDuration =
        const Duration(milliseconds: 300), 
    this.preferBelow = false, 
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      textStyle: TextStyle(
        color: AppColors.whiteColor,
        fontWeight: FontWeight.w500,
        fontSize: 15.sp,
      ),
      decoration: BoxDecoration(
        color: AppColors.canvasButtonColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      preferBelow: preferBelow,
      showDuration: showDuration, 
      waitDuration: waitDuration, 
      triggerMode:
          TooltipTriggerMode.tap, 
      child: AnimatedContainer(
        duration: showDuration,
        child: child,
      ),
    );
  }
}
