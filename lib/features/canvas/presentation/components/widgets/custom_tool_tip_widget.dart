import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomTooltip extends StatelessWidget {
  final String message;
  final Widget child;

  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      textStyle: TextStyle(
        color: AppColors.whiteColor,
        fontWeight: FontWeight.w500,
        fontSize: 12.sp,
      ),
      decoration: BoxDecoration(
        color: AppColors.canvasButtonColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      preferBelow: false,
      child: child,
    );
  }
}
