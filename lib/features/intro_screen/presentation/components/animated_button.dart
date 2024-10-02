import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socrita/features/intro_screen/presentation/components/color_list_tween.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const AnimatedButton(
      {super.key, required this.onPressed, required this.text});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _shadowColorAnimation;

  late Animation<Alignment> _beginAlignment;
  late Animation<Alignment> _endAlignment;
  late Animation<List<Color>> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _shadowColorAnimation = ColorTween(
      begin: Colors.black.withOpacity(0.2),
      end: Colors.blue.withOpacity(0.5),
    ).animate(_controller);

    _beginAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween:
              AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem(
          tween: AlignmentTween(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
      TweenSequenceItem(
          tween: AlignmentTween(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem(
          tween: AlignmentTween(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
    ]).animate(_controller);

    _endAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween: AlignmentTween(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem(
          tween: AlignmentTween(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
      TweenSequenceItem(
          tween:
              AlignmentTween(begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem(
          tween: AlignmentTween(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
    ]).animate(_controller);

    _colorAnimation = TweenSequence<List<Color>>([
      TweenSequenceItem(
        tween: ColorListTween(
          begin: [Colors.purpleAccent, Colors.blueAccent],
          end: [Colors.blueAccent, Colors.pinkAccent],
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorListTween(
          begin: [Colors.blueAccent, Colors.pinkAccent],
          end: const [Colors.pinkAccent, Color.fromARGB(255, 137, 200, 255)],
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorListTween(
          begin: const [Colors.pinkAccent, Color.fromARGB(255, 137, 200, 255)],
          end: const [Color.fromARGB(255, 137, 200, 255), Colors.purpleAccent],
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorListTween(
          begin: const [
            Color.fromARGB(255, 137, 200, 255),
            Colors.purpleAccent
          ],
          end: [Colors.purpleAccent, Colors.blueAccent],
        ),
        weight: 1,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHovered = true;
        _controller.forward();
      }),
      onExit: (_) => setState(() {
        _isHovered = false;
        _controller.reverse();
      }),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 250.w,
                height: 90.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isHovered
                        ? _colorAnimation.value
                        : [Colors.transparent, Colors.transparent],
                    begin: _beginAlignment.value,
                    end: _endAlignment.value,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? Colors.blueAccent.withOpacity(0.6)
                          : Colors.transparent,
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              child: ElevatedButton(
                onPressed: widget.onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: Size(150.w, 90.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: _isHovered ? 10 : 4,
                  shadowColor: _shadowColorAnimation.value,
                ),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 30.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
