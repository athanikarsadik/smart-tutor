import 'package:socratica/core/constants/asset_strings.dart';

enum DrawingTool {
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

enum SelectOptions {
  select,
  hand,
}

enum ShapeOptions { rectangle, line, square, arrow, circle }

enum DrawToolOptions {
  pencil,
  eraser,
}

enum MainDrawingTool {
  selectOptions,
  shapeOptions,
  drawToolOptions,
  text,
}

extension SelectOptionsExtension on SelectOptions {
  String getName() {
    switch (this) {
      case SelectOptions.select:
        return "Select";
      case SelectOptions.hand:
        return "Hand";
    }
  }

  String getAsset() {
    switch (this) {
      case SelectOptions.select:
        return AssetStrings.cursorSvg;
      case SelectOptions.hand:
        return AssetStrings.handSvg;
    }
  }

  List<String> getOptionsList() {
    return SelectOptions.values.map((e) => e.getName()).toList();
  }

  List<String> getAssetsList() {
    return SelectOptions.values.map((e) {
      return e.getAsset();
    }).toList();
  }

  static SelectOptions fromName(String name) {
    return SelectOptions.values.firstWhere(
      (e) => e.getName().toLowerCase() == name.toLowerCase(),
    );
  }
}

extension ShapeOptionsExtension on ShapeOptions {
  String getName() {
    switch (this) {
      case ShapeOptions.rectangle:
        return "Rectangle";
      case ShapeOptions.line:
        return "Line";
      case ShapeOptions.square:
        return "Square";
      case ShapeOptions.arrow:
        return "Arrow";
      case ShapeOptions.circle:
        return "Circle";
    }
  }

  String getAsset() {
    switch (this) {
      case ShapeOptions.arrow:
        return AssetStrings.arrowSvg;
      case ShapeOptions.line:
        return AssetStrings.lineSvg;
      case ShapeOptions.circle:
        return AssetStrings.circleSvg;
      case ShapeOptions.rectangle:
        return AssetStrings.rectSvg;
      case ShapeOptions.square:
        return AssetStrings.squareSvg;
    }
  }

  List<String> getOptionsList() {
    return ShapeOptions.values.map((e) => e.getName()).toList();
  }

  List<String> getAssetsList() {
    return ShapeOptions.values.map((e) {
      return e.getAsset();
    }).toList();
  }

  static ShapeOptions fromName(String name) {
    return ShapeOptions.values.firstWhere(
      (e) => e.getName().toLowerCase() == name.toLowerCase(),
    );
  }
}

extension DrawToolOptionsExtension on DrawToolOptions {
  String getName() {
    switch (this) {
      case DrawToolOptions.pencil:
        return "Pencil";
      case DrawToolOptions.eraser:
        return "Eraser";
    }
  }

  String getAsset() {
    switch (this) {
      case DrawToolOptions.eraser:
        return AssetStrings.eraserSvg;
      case DrawToolOptions.pencil:
        return AssetStrings.penSvg;
    }
  }

  List<String> getOptionsList() {
    return DrawToolOptions.values.map((e) => e.getName()).toList();
  }

  List<String> getAssetsList() {
    return DrawToolOptions.values.map((e) {
      return e.getAsset();
    }).toList();
  }

  static DrawToolOptions fromName(String name) {
    return DrawToolOptions.values.firstWhere(
      (e) => e.getName().toLowerCase() == name.toLowerCase(),
    );
  }
}

extension MainDrawingToolExtension on MainDrawingTool {
  String getName() {
    switch (this) {
      case MainDrawingTool.selectOptions:
        return "Select Options";
      case MainDrawingTool.shapeOptions:
        return "Shape Options";
      case MainDrawingTool.drawToolOptions:
        return "Draw Tool Options";
      case MainDrawingTool.text:
        return "Text";
    }
  }

  List<String> getOptionsList() {
    return MainDrawingTool.values.map((e) => e.getName()).toList();
  }
}
