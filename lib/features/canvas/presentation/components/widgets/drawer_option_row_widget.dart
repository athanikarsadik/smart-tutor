import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socratica/core/theme/app_colors.dart';

class DrawerOptionRowWidget extends StatelessWidget {
  final String leadingAsset;
  final String title;
  final String? hint;

  const DrawerOptionRowWidget({
    super.key,
    required this.leadingAsset,
    required this.title,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      minVerticalPadding: 0,
      dense: true,
      minTileHeight: 20.h,
      leading: SvgPicture.asset(
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
