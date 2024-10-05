import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:socrita/core/constants/show_snack_bar.dart';
import 'package:socrita/core/extensions/drawing_tool_extension.dart';
import 'package:socrita/features/canvas/domain/entities/chat_message_entity.dart';
import 'package:socrita/features/canvas/domain/usecase/send_chat_message.dart';
import 'package:toastification/toastification.dart';
import '../../../../secrets.dart';
import '../../domain/entities/drawing_tool_entity.dart';
import '../../domain/entities/stroke_entity.dart';
import 'dart:html' as html;

class HomeController extends GetxController {
  RxBool isStreaming = false.obs;
  RxBool isDownload = false.obs;

  late GenerativeModel model;

  final SendChatMessage sendChatMessage;

  HomeController({required this.sendChatMessage});

  @override
  void onInit() {
    super.onInit();

    model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: GEMINI_API_KEY,
      generationConfig: GenerationConfig(
          responseMimeType: "text/plain",
          maxOutputTokens: 8192,
          topK: 64,
          topP: 0.95,
          temperature: 1),
      systemInstruction: Content(
        "system",
        [
          TextPart("""
You are '${selectedAIModel}', trained to use the Socratic method to teach various subjects, ranging from mathematics and science to philosophy and the arts. Your goal is to guide users to understand complex concepts through a series of thought-provoking questions. Adhere to these guidelines:

1. Ask open-ended questions that encourage critical thinking about the subject matter.

2. Re-think about what the user is asking and verify if it is relevent to current discussion or not if not then bring him back to current topic politely.

3. Each question should build upon the previous one, gradually leading the user towards a deeper understanding of the concept.

4. Avoid directly explaining concepts or providing answers. Instead, guide the user to discover insights themselves.

5. Ask questions that challenge assumptions and promote deeper analysis of the topic's core principles and implications.

6. Adapt your questions based on the user's responses and level of understanding.

7. If the user is stuck, provide a subtle hint through your questioning to guide them in the right direction.

8. Encourage the user to think about real-world applications, alternative perspectives, or potential implications of the concept being discussed.

9. Maintain a supportive and curious tone throughout the conversation.

10. At the end of the dialogue, ask the user to summarize their understanding of the topic.

Remember to tailor your approach to the specific subject being discussed, whether it's a scientific theory, mathematical problem, philosophical concept, historical event, or any other topic. Your goal is to foster independent thinking and deep comprehension across a wide range of disciplines.
""")
        ],
      ),
    );
  }

  // final ScrollController chatScrollController = ScrollController();
  // RxList<Content> chats = <Content>[].obs;
  RxList<ChatMessageEntity> newChats = <ChatMessageEntity>[].obs;

  final Rx<Color> selectedColor = MaterialColor(Colors.cyan.value, {}).obs;
  final Rx<Color> selectedBgColor = const Color(0xFF212123).obs;
  final RxDouble strokeSize = 5.0.obs;
  final RxDouble eraserSize = 10.0.obs;
  final RxDouble fontSize = 10.0.obs;

  //====================
  //new tools
  RxBool isChatDialog = true.obs;

  final List<Color> colorList = [
    Colors.red,
    Colors.black,
    Colors.green,
    Colors.lightGreen,
    Colors.blue,
    Colors.purple,
    Colors.cyan,
    Colors.cyanAccent,
  ];

  final List<Color> backgroundColors = const [
    Color(0xFF141414),
    Color(0xFF212123),
    Color(0xFF141A1C),
    Color(0xFF191521),
    Color(0xFF14171C),
    Color(0xFF0C1916),
    Color(0xFF190C0C),
  ];

  final Rx<DrawingTool> selectedDrawingTool = DrawingTool.select.obs;
  final Rx<MainDrawingTool> mainSelectedTool =
      Rx<MainDrawingTool>(MainDrawingTool.selectOptions);
  final Rx<SelectOptions> currentSelectOption =
      Rx<SelectOptions>(SelectOptions.select);
  final Rx<ShapeOptions> currentShapeOption =
      Rx<ShapeOptions>(ShapeOptions.line);
  final Rx<DrawToolOptions> currentDrawToolOption =
      Rx<DrawToolOptions>(DrawToolOptions.pencil);

  RxString selectedAIModel = 'socrita-flash'.obs;
  RxString selectedAIVoice = 'aura-asteria-en'.obs;

  final RxList<String> aiModels = [
    'socrita-flash',
    'socrita',
  ].obs;
  final RxList<String> aiVoices = [
    'aura-arcas-en',
    'aura-asteria-en',
    'aura-helios-en',
    'aura-athena-en',
  ].obs;
  final RxList<Stroke> selectedStrokes = <Stroke>[].obs;
  final Rx<Offset?> dragStartPosition = Rx<Offset?>(null);
  final Rx<Offset?> totalDragOffset = Rx<Offset?>(null);

  final RxInt currentPageIndex = 1.obs;

  // For managing the text editing state
  TextEditingController textEditingController = TextEditingController();
  FocusNode textFocusNode = FocusNode();
  Offset? textPosition;

  //====================

  // Canvas State
  final RxList<Stroke> strokes = <Stroke>[].obs;
  final Rx<Stroke?> currentStroke = Rxn<Stroke?>();
  final GlobalKey canvasGlobalKey = GlobalKey();
  final Rx<ui.Image?> backgroundImage = Rxn<ui.Image?>();

  // Undo/Redo
  final RxList<Stroke> _undoStack = <Stroke>[].obs;
  final RxList<Stroke> _redoStack = <Stroke>[].obs;

  // Drawing Actions

  void changeAIModel(int index) {
    if (index == 0) {
      model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: GEMINI_API_KEY,
        generationConfig: GenerationConfig(
            responseMimeType: "text/plain",
            maxOutputTokens: 8192,
            topK: 64,
            topP: 0.95,
            temperature: 1),
        systemInstruction: Content(
          "system",
          [
            TextPart("""
You are 'socrita-flash', trained to use the Socratic method to teach various subjects, ranging from mathematics and science to philosophy and the arts. Your goal is to guide users to understand complex concepts through a series of thought-provoking questions. Adhere to these guidelines:

1. Ask open-ended questions that encourage critical thinking about the subject matter.

2. Re-think about what the user is asking and verify if it is relevent to current discussion or not if not then bring him back to current topic politely.

3. Each question should build upon the previous one, gradually leading the user towards a deeper understanding of the concept.

4. Avoid directly explaining concepts or providing answers. Instead, guide the user to discover insights themselves.

5. Ask questions that challenge assumptions and promote deeper analysis of the topic's core principles and implications.

6. Adapt your questions based on the user's responses and level of understanding.

7. If the user is stuck, provide a subtle hint through your questioning to guide them in the right direction.

8. Encourage the user to think about real-world applications, alternative perspectives, or potential implications of the concept being discussed.

9. Maintain a supportive and curious tone throughout the conversation.

10. At the end of the dialogue, ask the user to summarize their understanding of the topic.

Remember to tailor your approach to the specific subject being discussed, whether it's a scientific theory, mathematical problem, philosophical concept, historical event, or any other topic. Your goal is to foster independent thinking and deep comprehension across a wide range of disciplines.
""")
          ],
        ),
      );
    } else {
      model = GenerativeModel(
        model: 'gemini-1.5-pro-latest',
        apiKey: GEMINI_API_KEY,
        generationConfig: GenerationConfig(
            responseMimeType: "text/plain",
            maxOutputTokens: 8192,
            topK: 64,
            topP: 0.95,
            temperature: 1),
        systemInstruction: Content(
          "system",
          [
            TextPart("""
You are 'socrita', You are an expert educator who effectively uses the Socratic method to guide learners in understanding concepts.
In addition to general Socratic questioning, you have the following two capabilities:
Guided Assistance:
If you notice the learner struggling, you provide one or two hints to help them progress. If they continue to face difficulties, you offer the answer to an intermediate question to maintain the flow of learning.
Conversation Control:
You are adept at managing the length of conversations, knowing when to conclude based on the complexity of the topic. Simpler topics require fewer exchanges, and you ensure conversations remain concise and productive.
""")
          ],
        ),
      );
    }
  }

  void onPanStart(Offset startPoint) {
    switch (selectedDrawingTool.value) {
      case DrawingTool.eraser:
        // _handleEraserStart(startPoint);
        break;
      case DrawingTool.text:
        _handleTextStart(startPoint);
        break;
      case DrawingTool.select:
        _handleSelectStart(startPoint);
        break;
      default:
        _handleDefaultStart(startPoint);
    }
    update();
  }

  void onPanUpdate(Offset newPoint) {
    switch (selectedDrawingTool.value) {
      case DrawingTool.eraser:
        // _handleEraserUpdate(newPoint);
        _eraseStrokes(newPoint);
        break;
      case DrawingTool.text:
        // Do nothing for text on update
        break;
      case DrawingTool.select:
        _handleSelectUpdate(newPoint);
        break;
      default:
        _handleDefaultUpdate(newPoint);
    }
    update();
  }

  void onPanEnd() {
    switch (selectedDrawingTool.value) {
      case DrawingTool.eraser:
        // _handleEraserEnd();
        break;
      case DrawingTool.text:
        _handleTextEnd();
        break;
      case DrawingTool.select:
        _handleSelectEnd();
        break;
      default:
        _handleDefaultEnd();
    }
    update();
  }

  void _eraseStrokes(Offset point) {
    strokes
        .removeWhere((stroke) => _doesStrokeIntersectWithEraser(stroke, point));
  }

  bool _doesStrokeIntersectWithEraser(Stroke stroke, Offset eraserPoint) {
    for (Offset point in stroke.points) {
      double distance = (point - eraserPoint).distance;
      if (distance <= eraserSize.value) {
        return true;
      }
    }
    return false;
  }

  void _handleTextStart(Offset startPoint) {
    textPosition = startPoint;
    textEditingController.clear();
    textFocusNode.requestFocus();
  }

  void _handleSelectStart(Offset startPoint) {
    if (selectedStrokes.isNotEmpty &&
        _isPointInsideSelectedStrokes(startPoint)) {
      dragStartPosition.value = startPoint;
      totalDragOffset.value = Offset.zero;
    } else {
      currentStroke.value = Stroke(
        points: [startPoint, startPoint],
        color: Colors.blue.withOpacity(0.3),
        size: 1,
        strokeType: StrokeType.select,
      );
      selectedStrokes.clear();
    }
  }

  void _handleDefaultStart(Offset startPoint) {
    currentStroke.value = Stroke(
      points: [startPoint],
      color: selectedColor.value,
      size: strokeSize.value,
      strokeType: selectedDrawingTool.value.strokeType,
    );
  }

  void _handleSelectUpdate(Offset newPoint) {
    if (dragStartPosition.value != null) {
      _updateDraggedStrokes(newPoint);
    } else if (currentStroke.value != null) {
      _updateSelectionArea(newPoint);
    }
  }

  void _handleDefaultUpdate(Offset newPoint) {
    _updateCurrentStroke(newPoint);
  }

  void _updateCurrentStroke(Offset newPoint) {
    if (currentStroke.value != null) {
      List<Offset> updatedPoints = List.from(currentStroke.value!.points)
        ..add(newPoint);
      currentStroke.value =
          currentStroke.value!.copyWith(points: updatedPoints);
    }
  }

  void _updateDraggedStrokes(Offset newPoint) {
    final dragOffset = newPoint - dragStartPosition.value!;
    totalDragOffset.value = totalDragOffset.value! + dragOffset;
    dragStartPosition.value = newPoint;
    _updateSelectedStrokesPosition(dragOffset);
  }

  void _updateSelectionArea(Offset newPoint) {
    currentStroke.value = currentStroke.value!.copyWith(
      points: [currentStroke.value!.points.first, newPoint],
    );
    _updateSelectedStrokes();
  }

  void _handleTextEnd() {
    if (textEditingController.text.isNotEmpty && textPosition != null) {
      strokes.add(Stroke(
        points: [textPosition!],
        color: selectedColor.value,
        size: fontSize.value,
        strokeType: StrokeType.text,
        text: textEditingController.text,
      ));
      textEditingController.clear();
      textFocusNode.unfocus();
      textPosition = null;
    }
  }

  void _handleSelectEnd() {
    dragStartPosition.value = null;
    totalDragOffset.value = null;
    currentStroke.value = null;
  }

  void _handleDefaultEnd() {
    if (currentStroke.value != null) {
      strokes.add(currentStroke.value!);
      currentStroke.value = null;
      _undoStack.clear();
      _redoStack.clear();
    }
  }

  void undo() {
    if (strokes.isNotEmpty) {
      _undoStack.add(strokes.removeLast());
      update();
    }
  }

  void redo() {
    if (_undoStack.isNotEmpty) {
      strokes.add(_undoStack.removeLast());
      update();
    }
  }

  void clear() {
    strokes.clear();
    _undoStack.clear();
    _redoStack.clear();
    backgroundImage.value = null;
    textEditingController.clear();
    update();
  }

  void changeColor(Color newColor) {
    selectedColor.value = MaterialColor(newColor.value, const {});
  }

  Future<Uint8List?> captureCanvasImage() async {
    try {
      RenderRepaintBoundary boundary = canvasGlobalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      showSnackBar(type: ToastificationType.error, msg: e.toString());
      return null;
    }
  }

  Future<void> exportImage() async {
    isDownload.value = true;
    try {
      Uint8List? imageData = await captureCanvasImage();
      if (imageData != null) {
        final blob = html.Blob([imageData]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement()
          ..href = url
          ..style.display = 'none'
          ..download = 'canvas_image.png';
        html.document.body?.children.add(anchor);
        anchor.click();
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      } else {
        print('Failed to capture canvas image');
      }
    } catch (e) {
      showSnackBar(type: ToastificationType.error, msg: e.toString());
    } finally {
      isDownload.value = false;
    }
  }

  Future<void> importImage() async {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    await uploadInput.onChange.first;
    if (uploadInput.files!.isNotEmpty) {
      final file = uploadInput.files![0];
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      await reader.onLoad.first;
      final result = reader.result as Uint8List;

      // Convert Uint8List to ui.Image
      final codec = await ui.instantiateImageCodec(result);
      final frameInfo = await codec.getNextFrame();
      final image = frameInfo.image;

      // Update the backgroundImage
      backgroundImage.value = image;

      // Trigger a repaint of the DrawingCanvas
      update();
    }
  }

  // Future<void> getResponse(String prompt, [Uint8List? imageBytes]) async {
  //   isStreaming.value = true;
  //   try {
  //     if (imageBytes != null) {
  //       chats.add(Content.data("image/png", imageBytes));
  //     }
  //     final chat = model.startChat(history: chats);
  //     await chat.sendMessage(Content.text(prompt));
  //   } catch (e) {
  //     showSnackBar(type: ToastificationType.error, msg: e.toString());
  //   } finally {
  //     isStreaming.value = false;

  //     update();
  //   }
  // }

  Future<void> getResponse(String text, [Uint8List? imageBytes]) async {
    isStreaming.value = true;

    final chatMessage = ChatMessageEntity(
      role: 'user',
      image: imageBytes,
      text: text,
    );

    newChats.add(chatMessage);

    final result = await sendChatMessage(
        chatMessage.copyWith(role: selectedAIModel.value));

    result.fold(
      (failure) {
        showSnackBar(type: ToastificationType.error, msg: failure.message);
        newChats.removeLast();
      },
      (updatedMessage) {
        newChats.add(updatedMessage);
      },
    );

    isStreaming.value = false;
    // update();
  }

  void _updateSelectedStrokes() {
    if (currentStroke.value?.strokeType == StrokeType.select) {
      final selectionRect = Rect.fromPoints(
        currentStroke.value!.points.first,
        currentStroke.value!.points.last,
      );

      selectedStrokes.value = strokes.where((stroke) {
        return stroke.points.any((point) => selectionRect.contains(point));
      }).toList();
    }
  }

  void _updateSelectedStrokesPosition(Offset dragOffset) {
    for (var i = 0; i < selectedStrokes.length; i++) {
      final stroke = selectedStrokes[i];
      final updatedPoints =
          stroke.points.map((point) => point + dragOffset).toList();
      selectedStrokes[i] = stroke.copyWith(points: updatedPoints);

      final index = strokes.indexWhere((s) => s == stroke);
      if (index != -1) {
        strokes[index] = selectedStrokes[i];
      }
    }
  }

  bool _isPointInsideSelectedStrokes(Offset point) {
    for (final stroke in selectedStrokes) {
      if (_isPointInsideStroke(point, stroke)) {
        return true;
      }
    }
    return false;
  }

  bool _isPointInsideStroke(Offset point, Stroke stroke) {
    switch (stroke.strokeType) {
      case StrokeType.rectangle:
      case StrokeType.square:
        final rect = Rect.fromPoints(stroke.points.first, stroke.points.last);
        return rect.contains(point);
      case StrokeType.circle:
        final center = stroke.points.first;
        final radius = (stroke.points.last - center).distance;
        return (point - center).distance <= radius;
      case StrokeType.line:
      case StrokeType.pencil:
      case StrokeType.eraser:
        return stroke.points
            .any((strokePoint) => (strokePoint - point).distance < 10);
      case StrokeType.text:
        if (stroke.text != null) {
          final textBounds = _getTextBounds(stroke);
          return textBounds.contains(point);
        }
        return false;
      default:
        return false;
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

  @override
  void onClose() {
    textEditingController.dispose();
    textFocusNode.dispose();
  }
}
