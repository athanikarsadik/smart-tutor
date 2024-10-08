import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socrita/core/theme/app_colors.dart';

class DrawerOptionRowWidget extends StatelessWidget {
  final String leadingAsset;
  final String title;
  final bool isLoading;
  final String? hint;

  const DrawerOptionRowWidget({
    super.key,
    required this.leadingAsset,
    required this.title,
    this.isLoading = false,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(8.sp),
      mouseCursor: SystemMouseCursors.click,
      minVerticalPadding: 0,
      dense: true,
      minTileHeight: 20.h,
      leading: isLoading
          ? SizedBox(
              width: 20.sp,
              height: 20.sp,
              child: const CircularProgressIndicator(
                color: AppColors.whiteColor,
                strokeWidth: 1.5,
              ),
            )
          : SvgPicture.asset(
              leadingAsset,
              height: 20.sp,
            ),
      title: Text(
        title,
        style: TextStyle(
            color: AppColors.canvasTextColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500),
      ),
      trailing: (hint != null)
          ? Text(
              hint!,
              style: TextStyle(
                  color: AppColors.canvasHintTextColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500),
            )
          : const SizedBox.shrink(),
    );
  }
}
