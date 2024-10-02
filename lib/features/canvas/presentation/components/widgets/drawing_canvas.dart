import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:socrita/core/extensions/drawing_tool_extension.dart';
import 'package:socrita/core/theme/app_colors.dart';
import '../../../domain/entities/stroke_entity.dart';
import '../../controllers/home_controller.dart';
import 'dart:math' as math;

class DrawingCanvas extends StatelessWidget {
  const DrawingCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return GetBuilder<HomeController>(
      init: controller,
      builder: (_) {
        return Stack(
          children: [
            MouseRegion(
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
            ),
            if (controller.textPosition != null)
              Obx(
                () => Positioned(
                  left: controller.textPosition!.dx,
                  top: controller.textPosition!.dy,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: TextField(
                      controller: controller.textEditingController,
                      focusNode: controller.textFocusNode,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: EdgeInsets.all(8.sp),
                      ),
                      style: TextStyle(
                        color: controller.selectedColor.value,
                        fontSize: controller.fontSize.value,
                      ),
                      onSubmitted: (_) => controller.onPanEnd(),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _DrawingCanvasPainter extends CustomPainter {
  final HomeController _controller = Get.find<HomeController>();

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackgroundImage(canvas, size);
    _drawStrokes(canvas);
    _drawCurrentStroke(canvas);
    _drawSelectedStrokes(canvas);
    _drawTextStrokes(canvas);
  }

  void _drawTextStrokes(Canvas canvas) {
    final textStrokes = _controller.strokes
        .where((stroke) => stroke.strokeType == StrokeType.text);
    for (final stroke in textStrokes) {
      if (stroke.text != null) {
        final textSpan = TextSpan(
          text: stroke.text,
          style: TextStyle(
            color: stroke.color,
            fontSize: stroke.size,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final offset = stroke.points.first + stroke.offset;
        textPainter.paint(canvas, offset);
      }
    }
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
        Rect.fromLTWH(size.width / 2, size.height / 2, 200, 200),
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

      switch (stroke.strokeType) {
        case StrokeType.select:
          paint.color = AppColors.canvasButtonColor.withOpacity(0.3);
          paint.strokeWidth = 1.0;
          final rect = Rect.fromPoints(
            stroke.points.first,
            stroke.points.last,
          );
          canvas.drawRect(rect, paint);
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
          _drawArrow(canvas, stroke.points.first, stroke.points.last, paint);

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
        case StrokeType.text:
          if (stroke.text != null) {
            final textSpan = TextSpan(
              text: stroke.text,
              style: TextStyle(
                color: stroke.color,
                fontSize: stroke.size,
              ),
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout();
            final offset = stroke.points.first + stroke.offset;
            textPainter.paint(canvas, offset);
          }
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
        case StrokeType.arrow:
          _drawArrow(canvas, currentStroke.points.first,
              currentStroke.points.last, paint);
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
          paint.color = AppColors.whiteColor.withOpacity(0.3);
          paint.strokeWidth = 1.0;
          final rect = Rect.fromPoints(
            currentStroke.points.first,
            currentStroke.points.last,
          );
          canvas.drawRect(rect, paint);
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
          final path = Path();
          for (int i = 0; i < currentStroke.points.length; i++) {
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
        case StrokeType.text:
          break;
      }
    }
  }

  void _drawSelectedStrokes(Canvas canvas) {
    final highlightPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final stroke in _controller.selectedStrokes) {
      _drawStroke(canvas, stroke, highlightPaint);
    }
  }

  void _drawStroke(Canvas canvas, Stroke stroke, Paint paint) {
    switch (stroke.strokeType) {
      case StrokeType.pencil:
      case StrokeType.eraser:
        // final path = Path();
        // path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
        // for (final point in stroke.points.skip(1)) {
        //   path.lineTo(point.dx, point.dy);
        // }
        // canvas.drawPath(path, paint);
        break;
      case StrokeType.line:
        canvas.drawLine(stroke.points.first, stroke.points.last, paint);
        break;
      case StrokeType.rectangle:
      case StrokeType.square:
        final rect = Rect.fromPoints(stroke.points.first, stroke.points.last);
        canvas.drawRect(rect, paint);
        break;
      case StrokeType.circle:
        final center = stroke.points.first;
        final radius = (stroke.points.last - center).distance;
        canvas.drawCircle(center, radius, paint);
        break;
      case StrokeType.text:
        if (stroke.text != null) {
          final textBounds = _getTextBounds(stroke);
          canvas.drawRect(textBounds, paint);
        }
        break;
      default:
        // Handle other stroke types as needed
        break;
    }
  }

  Rect _getTextBounds(Stroke stroke) {
    final textSpan = TextSpan(
      text: stroke.text,
      style: TextStyle(fontSize: stroke.size),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return Rect.fromPoints(
      stroke.points.first,
      stroke.points.first + Offset(textPainter.width, textPainter.height),
    );
  }

  void _drawArrow(Canvas canvas, Offset start, Offset end, Paint paint) {
    canvas.drawLine(start, end, paint);

    final arrowHeadSize = 30.0.sp;
    final angle = (end - start).direction;
    final arrowHeadPoint1 =
        end - Offset.fromDirection(angle - math.pi / 6, arrowHeadSize);
    final arrowHeadPoint2 =
        end - Offset.fromDirection(angle + math.pi / 6, arrowHeadSize);

    final path = Path();
    path.moveTo(end.dx, end.dy);
    path.lineTo(arrowHeadPoint1.dx, arrowHeadPoint1.dy);
    path.lineTo(arrowHeadPoint2.dx, arrowHeadPoint2.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_DrawingCanvasPainter oldDelegate) {
    return true;
  }
}
