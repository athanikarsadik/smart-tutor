import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socrita/features/canvas/presentation/components/widgets/custom_tool_tip_widget.dart';

class AnimatedIconButton extends StatefulWidget {
  final double width;
  final double height;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color shadowColor;
  final String iconPath;
  final ColorFilter? colorFilter;
  final GestureTapCallback callbackAction;
  final String message;

  const AnimatedIconButton({
    super.key,
    required this.width,
    required this.message,
    required this.callbackAction,
    required this.height,
    required this.padding,
    required this.backgroundColor,
    required this.shadowColor,
    required this.iconPath,
    this.colorFilter,
  });

  @override
  State createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTooltip(
      message: widget.message,
      child: GestureDetector(
        onTap: widget.callbackAction,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.width,
                height: widget.height,
                padding: widget.padding,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: widget.shadowColor,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      blurRadius: 4,
                      color: widget.shadowColor,
                      offset: const Offset(4, 0),
                      spreadRadius: 0,
                    ),
                  ],
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: SvgPicture.asset(
                  widget.iconPath,
                  colorFilter: widget.colorFilter,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
