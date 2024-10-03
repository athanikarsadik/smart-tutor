import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomDropdownButton extends StatelessWidget {
  final String selectedValue;
  final List<List<String>> items;
  final ValueChanged<String?> onChanged;
  final Widget? child;
  final double? paddingHor;

  const CustomDropdownButton({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.child,
    this.paddingHor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: paddingHor ?? 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: child == null ? AppColors.canvasChatQColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: PopupMenuButton<String>(
        tooltip: "",
        initialValue: selectedValue,
        offset: Offset(0, 60.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        color: AppColors.canvasDropdownColor,
        itemBuilder: (BuildContext context) {
          return List.generate(items[0].length, (index) {
            String value = items[0][index];
            String? svgAsset = items.length > 1 ? items[1][index] : null;

            return PopupMenuItem<String>(
              value: value,
              child: ListTile(
                leading: (svgAsset != null)
                    ? SvgPicture.asset(
                        svgAsset,
                        width: 20.w,
                        height: 20.h,
                      )
                    : SizedBox.shrink(),
                title: Text(
                  value,
                  style:
                      TextStyle(fontSize: 18.sp, color: AppColors.whiteColor),
                ),
                trailing: selectedValue == value
                    ? Icon(
                        Icons.check,
                        color: AppColors.whiteColor,
                        size: 15.sp,
                      )
                    : SizedBox(
                        width: 15.sp,
                      ),
              ),

              // Row(
              //   children: [
              //     selectedValue == value
              //         ? Icon(
              //             Icons.check,
              //             color: AppColors.whiteColor,
              //             size: 15.sp,
              //           )
              //         : SizedBox(
              //             width: 15.sp,
              //           ),
              //     SizedBox(width: 10.w),
              //     if (svgAsset != null)
              //       SvgPicture.asset(
              //         svgAsset,
              //         width: 20.w,
              //         height: 20.h,
              //       ),
              //     SizedBox(width: 20.w),
              //     Text(
              //       value,
              //       style: const TextStyle(color: AppColors.whiteColor),
              //     ),
              //   ],
              // ),
            );
          }).toList();
        },
        onSelected: (String newValue) {
          onChanged(newValue);
        },
        child: child ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedValue,
                  style:
                      TextStyle(color: AppColors.whiteColor, fontSize: 18.sp),
                ),
                SizedBox(width: 5.w),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.whiteColor,
                  size: 20.sp,
                  weight: 2,
                ),
              ],
            ),
      ),
    );
  }
}
