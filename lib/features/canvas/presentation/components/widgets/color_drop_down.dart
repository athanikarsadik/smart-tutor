import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class HorizontalColorDropdown extends StatelessWidget {
  final Color selectedValue;
  final List<Color> colors;
  final ValueChanged<Color> onChanged;
  final Offset offset;

  const HorizontalColorDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.colors,
    this.offset = const Offset(0, 50),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
        decoration: BoxDecoration(
          color: AppColors.canvasSecondaryColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 25.sp,
              height: 25.sp,
              decoration: BoxDecoration(
                color: selectedValue,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.canvasBorderColor),
              ),
            ),
            SizedBox(width: 5.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.whiteColor,
              size: 20.sp,
            ),
          ],
        ),
      ),
      onTap: () {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(offset, ancestor: overlay),
            button.localToGlobal(button.size.bottomRight(offset),
                ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        );

        showMenu<Color>(
          context: context,
          position: position,
          items: [
            PopupMenuItem<Color>(
              enabled: false,
              child: SizedBox(
                height: 75.h,
                width: 350.w,
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 3.0.w,
                  radius: Radius.circular(8.r),
                  controller: ScrollController(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      Color color = colors[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 10.h),
                        child: GestureDetector(
                          onTap: () {
                            onChanged(color);
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            radius: 20.r,
                            backgroundColor: selectedValue ==
                                    MaterialColor(color.value, const {})
                                ? AppColors.canvasButtonColor
                                : AppColors.canvasSecondaryColor,
                            child: Container(
                              width: 35.w,
                              height: 35.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
          elevation: 8,
        );
      },
    );
  }
}
