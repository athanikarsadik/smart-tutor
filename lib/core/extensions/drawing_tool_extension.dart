import 'package:flutter/material.dart';

import '../../features/canvas/domain/entities/drawing_tool_entity.dart';
import '../../features/canvas/domain/entities/stroke_entity.dart';

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
      case DrawingTool.text:
        return StrokeType.text;
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
      case DrawingTool.text:
        return "Text";
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
        return SystemMouseCursors.basic;
      case StrokeType.pencil:
        return SystemMouseCursors.precise;
      case StrokeType.hand:
        return SystemMouseCursors.grab;
      case StrokeType.line:
        return SystemMouseCursors.precise;
      case StrokeType.rectangle:
        return SystemMouseCursors.precise;
      case StrokeType.arrow:
        return SystemMouseCursors.precise;
      case StrokeType.circle:
        return SystemMouseCursors.precise;
      case StrokeType.square:
        return SystemMouseCursors.precise;
      case StrokeType.eraser:
        return SystemMouseCursors.cell;
      case StrokeType.text:
        return SystemMouseCursors.text;
    }
  }
}
