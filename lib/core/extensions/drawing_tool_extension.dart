import 'package:flutter/material.dart';

import '../../features/calculator/domain/entities/drawing_tool_entity.dart';
import '../../features/calculator/domain/entities/stroke_entity.dart';

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
    }
  }

  MouseCursor get cursor {
    switch (strokeType) {
      case StrokeType.select:
        return SystemMouseCursors.click;
      case StrokeType.pencil:
      case StrokeType.line:
      case StrokeType.circle:
      case StrokeType.square:
        return SystemMouseCursors.precise;
      case StrokeType.eraser:
        return SystemMouseCursors.cell;
    }
  }
}
