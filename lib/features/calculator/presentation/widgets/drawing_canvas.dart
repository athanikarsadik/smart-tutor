import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_calculator/core/extensions/drawing_tool_extension.dart';
import 'package:smart_calculator/core/theme/app_colors.dart';
import 'package:smart_calculator/features/calculator/domain/entities/stroke_entity.dart';

import '../controller/calculator_controller.dart';

class DrawingCanvas extends StatelessWidget {
  const DrawingCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalculatorController>();

    return GetBuilder<CalculatorController>(
        init: controller,
        builder: (_) {
          return MouseRegion(
            cursor: controller.selectedDrawingTool.value.cursor,
            child: GestureDetector(
              onPanStart: (details) {
                final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                final localPosition =
                    renderBox.globalToLocal(details.globalPosition);
                controller.onPanStart(localPosition);
              },
              onPanUpdate: (details) {
                final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                final localPosition =
                    renderBox.globalToLocal(details.globalPosition);
                controller.onPanUpdate(localPosition);
              },
              onPanEnd: (details) => controller.onPanEnd(),
              child: CustomPaint(
                painter: _DrawingCanvasPainter(),
                size: Size.infinite,
              ),
            ),
          );
        });
  }
}

class _DrawingCanvasPainter extends CustomPainter {
  final CalculatorController _controller = Get.find<CalculatorController>();

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackgroundImage(canvas, size);
    _drawStrokes(canvas);
    _drawCurrentStroke(canvas);
  }

  void _drawBackgroundImage(Canvas canvas, Size size) {
    if (_controller.backgroundImage.value != null) {
      canvas.drawImageRect(
        _controller.backgroundImage.value!,
        Rect.fromLTWH(
          0,
          0,
          _controller.backgroundImage.value!.width.toDouble(),
          _controller.backgroundImage.value!.height.toDouble(),
        ),
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint(),
      );
    }
  }

  void _drawStrokes(Canvas canvas) {
    for (final stroke in _controller.strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.size
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      if (stroke.strokeType == StrokeType.eraser) {
        paint.color = AppColors.canvasBgColor!;
        paint.blendMode = BlendMode.clear;
      }

      switch (stroke.strokeType) {
        // Add switch statement here
        case StrokeType.select:
          break;
        case StrokeType.pencil:
        case StrokeType.eraser: // Eraser will also use path drawing
          final path = Path();
          for (int i = 0; i < stroke.points.length; i++) {
            // Iterate through all points
            if (i == 0) {
              path.moveTo(stroke.points[i].dx, stroke.points[i].dy);
            } else {
              path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
            }
          }
          canvas.drawPath(path, paint);
          break;
        case StrokeType.line:
          canvas.drawLine(
            stroke.points.first,
            stroke.points.last,
            paint,
          );
          break;

        case StrokeType.circle:
          final center = stroke.points.first;
          final radius = (stroke.points.last - center).distance;
          canvas.drawCircle(center, radius, paint);
          break;

        case StrokeType.square:
          final rect = Rect.fromPoints(
            stroke.points.first,
            stroke.points.last,
          );
          canvas.drawRect(rect, paint);
          break;
      }
    }
  }

  void _drawCurrentStroke(Canvas canvas) {
    final currentStroke = _controller.currentStroke.value;
    if (currentStroke != null && currentStroke.points.isNotEmpty) {
      final paint = Paint()
        ..color = currentStroke.color
        ..strokeWidth = currentStroke.size
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      switch (currentStroke.strokeType) {
        case StrokeType.select:
          break;
        case StrokeType.pencil:
          final path = Path();
          path.moveTo(currentStroke.points[0].dx, currentStroke.points[0].dy);
          for (int i = 1; i < currentStroke.points.length; i++) {
            path.lineTo(currentStroke.points[i].dx, currentStroke.points[i].dy);
          }
          canvas.drawPath(path, paint);
          break;

        case StrokeType.line:
          canvas.drawLine(
            currentStroke.points.first,
            currentStroke.points.last,
            paint,
          );
          break;

        case StrokeType.circle:
          final center = currentStroke.points.first;
          final radius = (currentStroke.points.last - center).distance;
          canvas.drawCircle(center, radius, paint);
          break;

        case StrokeType.square:
          final rect = Rect.fromPoints(
            currentStroke.points.first,
            currentStroke.points.last,
          );
          canvas.drawRect(rect, paint);
          break;

        case StrokeType.eraser:
          paint.color = AppColors.canvasBgColor!;
          paint.blendMode = BlendMode.clear;
          final path = Path();
          for (int i = 0; i < currentStroke.points.length - 1; i++) {
            if (i == 0) {
              path.moveTo(
                  currentStroke.points[i].dx, currentStroke.points[i].dy);
            } else {
              path.lineTo(
                  currentStroke.points[i].dx, currentStroke.points[i].dy);
            }
          }
          canvas.drawPath(path, paint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(_DrawingCanvasPainter oldDelegate) {
    return true;
  }
}
