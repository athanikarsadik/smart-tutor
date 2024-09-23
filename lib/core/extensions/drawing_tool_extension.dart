import 'package:flutter/material.dart';

import '../../features/home/domain/entities/drawing_tool_entity.dart';
import '../../features/home/domain/entities/stroke_entity.dart';

extension DrawingToolExtension on DrawingTool {
  StrokeType get strokeType {
    switch (this) {
      case DrawingTool.select:
        return StrokeType.select;
      case DrawingTool.pencil:
        return StrokeType.pencil;
      case DrawingTool.eraser:
        return StrokeType.eraser;
      case DrawingTool.line:
        return StrokeType.line;
      case DrawingTool.circle:
        return StrokeType.circle;
      case DrawingTool.square:
        return StrokeType.square;
      case DrawingTool.arrow:
        return StrokeType.arrow;
      case DrawingTool.rectangle:
        return StrokeType.rectangle;
      case DrawingTool.hand:
        return StrokeType.hand;
    }
  }

  String getName() {
    switch (this) {
      case DrawingTool.rectangle:
        return "Rectangle";
      case DrawingTool.line:
        return "Line";
      case DrawingTool.square:
        return "Square";
      case DrawingTool.arrow:
        return "Arrow";
      case DrawingTool.circle:
        return "Circle";
      case DrawingTool.select:
        return "Select";
      case DrawingTool.hand:
        return "Hand";
      case DrawingTool.eraser:
        return "Eraser";
      case DrawingTool.pencil:
        return "Pencil";
    }
  }

  static DrawingTool fromName(String name) {
    return DrawingTool.values.firstWhere(
      (e) => e.getName().toLowerCase() == name.toLowerCase(),
    );
  }

  MouseCursor get cursor {
    switch (strokeType) {
      case StrokeType.select:
        return SystemMouseCursors.click;
      case StrokeType.pencil:
      case StrokeType.hand:
        return SystemMouseCursors.click;
      case StrokeType.line:
      case StrokeType.rectangle:
      case StrokeType.arrow:
      case StrokeType.circle:
      case StrokeType.square:
        return SystemMouseCursors.precise;
      case StrokeType.eraser:
        return SystemMouseCursors.cell;
    }
  }
}
