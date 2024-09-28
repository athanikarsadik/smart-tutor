import 'package:flutter/material.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double size;
  final StrokeType strokeType;
  String? text;
  bool isSelected;
  Offset offset;

  Stroke({
    required this.points,
    required this.color,
    required this.size,
    required this.strokeType,
    this.isSelected = false,
    this.text,
    this.offset = Offset.zero,
  });

  Stroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    StrokeType? strokeType,
    bool? isSelected,
    Offset? offset,
    String? text,
  }) {
    return Stroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      strokeType: strokeType ?? this.strokeType,
      isSelected: isSelected ?? this.isSelected,
      offset: offset ?? this.offset,
      text: text ?? this.text,
    );
  }
}

enum StrokeType {
  select,
  hand,
  rectangle,
  line,
  square,
  arrow,
  circle,
  pencil,
  eraser,
  text,
}
