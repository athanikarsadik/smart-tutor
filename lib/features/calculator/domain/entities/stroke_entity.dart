import 'package:flutter/material.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double size;
  final StrokeType strokeType;

  Stroke({
    required this.points,
    required this.color,
    required this.size,
    required this.strokeType,
  });

  Stroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    StrokeType? strokeType,
  }) {
    return Stroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      strokeType: strokeType ?? this.strokeType,
    );
  }

  Stroke.fromJson(Map<String, dynamic> json)
      : points = (json['points'] as List<dynamic>)
            .map((point) => Offset(point[0] as double, point[1] as double))
            .toList(),
        color = Color(int.parse(json['color'] as String, radix: 16)),
        size = json['size'] as double,
        strokeType = StrokeType.values[json['strokeType'] as int];
}

enum StrokeType {
  select,
  pencil,
  eraser,
  line,
  circle,
  square,
}
