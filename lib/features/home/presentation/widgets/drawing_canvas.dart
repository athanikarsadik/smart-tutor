import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socratica/core/extensions/drawing_tool_extension.dart';
import 'package:socratica/core/theme/app_colors.dart';
import 'package:socratica/features/home/domain/entities/stroke_entity.dart';
import 'dart:math' as math;
import '../controller/home_controller.dart';

class DrawingCanvas extends StatelessWidget {
  const DrawingCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return GetBuilder<HomeController>(
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
  final HomeController _controller = Get.find<HomeController>();

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
        paint.color = AppColors.canvasPrimaryColor;
        paint.blendMode = BlendMode.clear;
      }

      switch (stroke.strokeType) {
        case StrokeType.select:
          break;
        case StrokeType.pencil:
          final path = Path();
          for (int i = 0; i < stroke.points.length - 1; i++) {
            if (i == 0) {
              path.moveTo(stroke.points[i].dx, stroke.points[i].dy);
            } else {
              path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
            }
          }
          canvas.drawPath(path, paint);
          break;
        case StrokeType.arrow:
          break;
        case StrokeType.hand:
          break;
        case StrokeType.rectangle:
          final rect = Rect.fromPoints(
            stroke.points.first,
            stroke.points.last,
          );
          canvas.drawRect(rect, paint);

          break;
        case StrokeType.eraser:
          final path = Path();
          for (int i = 0; i < stroke.points.length; i++) {
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
          final diagonal = (stroke.points.last - stroke.points.first).distance;
          final center = (stroke.points.first + stroke.points.last) / 2;
          final halfDiagonal = diagonal / 2;
          final sqaure = Rect.fromCenter(
            center: center,
            width: halfDiagonal,
            height: halfDiagonal,
          );

          canvas.drawRect(sqaure, paint);
          break;
      }
      if (stroke.strokeType == StrokeType.select) {
        final selectionPaint = Paint()
          ..color = Colors.blue
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
        canvas.drawRect(_getStrokeRect(stroke), selectionPaint);
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
        case StrokeType.arrow:
          break;
        case StrokeType.hand:
          break;
        case StrokeType.rectangle:
          final rect = Rect.fromPoints(
            currentStroke.points.first,
            currentStroke.points.last,
          );
          canvas.drawRect(rect, paint);
          break;
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
          final diagonal =
              (currentStroke.points.last - currentStroke.points.first).distance;
          final center =
              (currentStroke.points.first + currentStroke.points.last) / 2;
          final halfDiagonal = diagonal / 2;
          final sqaure = Rect.fromCenter(
            center: center,
            width: halfDiagonal,
            height: halfDiagonal,
          );

          canvas.drawRect(sqaure, paint);
          break;

        case StrokeType.eraser:
          paint.color = AppColors.canvasPrimaryColor;
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

  Rect _getStrokeRect(Stroke stroke) {
    final minX =
        stroke.points.map((p) => p.dx + stroke.offset.dx).reduce(math.min);
    final maxX =
        stroke.points.map((p) => p.dx + stroke.offset.dx).reduce(math.max);
    final minY =
        stroke.points.map((p) => p.dy + stroke.offset.dx).reduce(math.min);
    final maxY =
        stroke.points.map((p) => p.dy + stroke.offset.dx).reduce(math.max);
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  @override
  bool shouldRepaint(_DrawingCanvasPainter oldDelegate) {
    return true;
  }
}
