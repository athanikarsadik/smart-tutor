import 'package:flutter/material.dart';
import 'package:smart_calculator/features/calculator/domain/entities/drawing_tool_entity.dart';

class CustomCursor extends StatelessWidget {
  final bool isVisible;
  final Offset position;
  final double size;
  final DrawingTool cursorType;

  const CustomCursor({
    super.key,
    required this.isVisible,
    required this.position,
    required this.size,
    required this.cursorType,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Positioned(
        left: position.dx - (size / 2), // Center the cursor
        top: position.dy - (size / 2), // Center the cursor
        child: _buildCursorWidget(cursorType, size),
      ),
    );
  }

  Widget _buildCursorWidget(DrawingTool tool, double size) {
    switch (tool) {
      case DrawingTool.pencil:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.5),
          ),
        );
      case DrawingTool.eraser:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
        );
      // Add more cases for other drawing tools
      default:
        return const SizedBox.shrink(); // Or a default cursor
    }
  }
}
