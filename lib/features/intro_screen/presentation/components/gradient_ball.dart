import 'package:flutter/material.dart';

class GradientBall extends StatelessWidget {
  final double size;
  final List<Color> colors;

  const GradientBall({super.key, required this.size, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: colors,
          center:const Alignment(0.0, 0.0),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.7),
            blurRadius: 500,
            spreadRadius: 60,
          ),
        ],
      ),
    );
  }
}
