import 'dart:ui';

import 'package:flutter/material.dart';

class ColorListTween extends Tween<List<Color>> {
  ColorListTween({required List<Color> begin, required List<Color> end})
      : super(begin: begin, end: end);

  @override
  List<Color> lerp(double t) {
    return List.generate(
      begin!.length,
      (i) => Color.lerp(begin![i], end![i], t)!,
    );
  }
}
