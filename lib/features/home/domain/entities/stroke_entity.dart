import 'package:flutter/material.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double size;
  final StrokeType strokeType;
  bool isSelected;
  Offset offset;

  Stroke({
    required this.points,
    required this.color,
    required this.size,
    required this.strokeType,
    this.isSelected = false,
    this.offset = Offset.zero,
  });

  Stroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    StrokeType? strokeType,
    bool? isSelected,
    Offset? offset,
  }) {
    return Stroke(
      points: points ?? this.points,
      color: color ?? this.color,
      size: size ?? this.size,
      strokeType: strokeType ?? this.strokeType,
      isSelected: isSelected ?? this.isSelected,
      offset: offset ?? this.offset,
    );
  }

  Stroke.fromJson(Map<String, dynamic> json)
      : points = (json['points'] as List<dynamic>)
            .map((point) => Offset(point[0] as double, point[1] as double))
            .toList(),
        color = Color(int.parse(json['color'] as String, radix: 16)),
        size = json['size'] as double,
        strokeType = StrokeType.values[json['strokeType'] as int],
        offset = Offset(json['offsetX'] as double? ?? 0.0,
            json['offsetY'] as double? ?? 0.0),
        isSelected = json['isSelected'] as bool? ?? false;

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => [point.dx, point.dy]).toList(),
      'color': color.value.toString(),
      'size': size,
      'strokeType': strokeType.index,
      'offsetX': offset.dx,
      'offsetY': offset.dy,
      'isSelected': isSelected,
    };
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
}
