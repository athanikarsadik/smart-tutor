import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socratica/core/theme/app_colors.dart';

class AnimatedColorPalette extends StatefulWidget {
  final List<Color> colors;
  final Function(Color) onColorSelected;

  const AnimatedColorPalette({
    super.key,
    required this.colors,
    required this.onColorSelected,
  });

  @override
  createState() => _AnimatedColorPaletteState();
}

class _AnimatedColorPaletteState extends State<AnimatedColorPalette> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.sp,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.colors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onColorSelected(widget.colors[index]);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
              width: _selectedIndex == index ? 50.sp : 40.sp,
              height: _selectedIndex == index ? 50.sp : 40.sp,
              decoration: BoxDecoration(
                color: widget.colors[index],
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: _selectedIndex == index
                      ? AppColors.canvasBorderColor
                      : AppColors.borderColor,
                  width: 2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
