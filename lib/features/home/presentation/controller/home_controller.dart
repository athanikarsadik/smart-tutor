import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:socratica/core/extensions/drawing_tool_extension.dart';
import 'package:socratica/core/theme/app_colors.dart';
import '../../../../secrets.dart';
import '../../domain/entities/drawing_tool_entity.dart';
import '../../domain/entities/stroke_entity.dart';
import 'dart:math' as math;

class HomeController extends GetxController {
  RxBool isCalculating = false.obs;
  RxBool isExpanded = false.obs;
  RxBool isStreaming = false.obs;

  late GenerativeModel model;

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
You are an AI assistant trained to use the Socratic method to teach various subjects, ranging from mathematics and science to philosophy and the arts. Your goal is to guide users to understand complex concepts through a series of thought-provoking questions. Adhere to these guidelines:

1. Ask open-ended questions that encourage critical thinking about the subject matter.

2. Limit your questions to 5-10 per topic to maintain focus and avoid overwhelming the user.

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

  final ScrollController chatScrollController = ScrollController();
  RxList<Content> chats = <Content>[
    Content("user", [
      TextPart(
          "Can you help me understand the insertion sort algorithm? I'm having trouble implementing it.")
    ]),
    Content("model", [
      TextPart(
          "Of course! Let's explore insertion sort together. To begin, can you describe how you might sort a small pile of papers with numbers written on them?")
    ]),
    Content("user", [
      TextPart(
          "I guess I'd look through them and put the smallest number on top, then the next smallest, and so on.")
    ]),
    Content("model", [
      TextPart(
          "That's a good start! You're describing a sorting method, but not quite insertion sort. Let's try a different approach. Imagine you're dealing cards into a sorted hand. How would you insert a new card into its correct position in an already sorted portion of your hand?")
    ]),
    Content("user", [
      TextPart(
          "I'd compare the new card with the ones in my hand, starting from the right, and slide it in where it fits.")
    ]),
    Content("model", [
      TextPart(
          "Excellent! You've grasped a key concept of insertion sort. Now, thinking about this in terms of an array of numbers, how might you represent the 'sorted' and 'unsorted' portions of the array as you progress through the sorting process?")
    ]),
    Content("user", [
      TextPart(
          "I suppose the left side would be sorted, and the right side unsorted. As I go through the array, the sorted portion would grow.")
    ]),
    Content("model", [
      TextPart(
          "Perfect understanding! Now, let's focus on the process of inserting an element. When you find the correct position for an element in the sorted portion, what needs to happen to the elements that are greater than the one you're inserting?")
    ]),
    Content("user", [
      TextPart(
          "They need to be moved to the right to make room for the new element.")
    ]),
    Content("model", [
      TextPart(
          "Exactly right! You're describing the key operations of insertion sort. Now, thinking about implementing this in code, what kind of loop structure might you use to iterate through the array and perform these operations?")
    ]),
    Content("user", [
      TextPart(
          "I think I'd need two loops. One to go through the whole array, and another to handle the sorting and shifting within the sorted portion.")
    ]),
    Content("model", [
      TextPart(
          "Great insight! You're on the right track with the nested loop structure. Can you describe in more detail how these two loops would work together? What would be the purpose of each loop, and what would their start and end conditions be?")
    ]),
    Content("user", [
      TextPart(
          "The outer loop would start from the second element and go to the end of the array. The inner loop would start from the current element of the outer loop and move left, comparing and shifting elements as needed.")
    ]),
    Content("model", [
      TextPart(
          "Excellent breakdown! You've grasped the core structure of the insertion sort algorithm. Now, let's think about efficiency. In the worst-case scenario, how many comparisons and shifts might you need to perform for each element you're inserting?")
    ]),
    Content("user", [
      TextPart(
          "In the worst case, I guess I'd need to compare with every element in the sorted portion and shift all of them.")
    ]),
    Content("model", [
      TextPart(
          "You're absolutely right. Given this worst-case scenario, can you think of a type of input array that would cause insertion sort to perform the maximum number of operations? And how might this affect the algorithm's time complexity?")
    ]),
    Content("user", [
      TextPart(
          "An array in reverse order would be the worst case. Each element would need to be moved to the beginning. I think this would make the time complexity O(n^2).")
    ]),
    Content("model", [
      TextPart(
          "Excellent analysis! You've correctly identified both the worst-case scenario and its impact on time complexity. Now, as a final question, can you think of any scenarios where insertion sort might perform better than other sorting algorithms, despite its O(n^2) worst-case time complexity?")
    ]),
    Content("user", [
      TextPart(
          "Maybe if the array is already mostly sorted? Or if we're dealing with a small number of elements?")
    ]),
    Content("model", [
      TextPart(
          "Great insights! You've identified key situations where insertion sort can be advantageous. To wrap up our discussion, could you summarize the main steps of the insertion sort algorithm and highlight its strengths and limitations based on what we've explored?")
    ]),
  ].obs;

  final Rx<Color> selectedColor = MaterialColor(Colors.black.value, {}).obs;
  final RxDouble strokeSize = 5.0.obs;
  final RxDouble eraserSize = 10.0.obs;

  //====================
  //new tools

  Offset? _selectionStart;
  Stroke? _selectedStroke;

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

  final Rx<DrawingTool> selectedDrawingTool = DrawingTool.select.obs;
  final Rx<MainDrawingTool> mainSelectedTool =
      Rx<MainDrawingTool>(MainDrawingTool.selectOptions);
  final Rx<SelectOptions> currentSelectOption =
      Rx<SelectOptions>(SelectOptions.select);
  final Rx<ShapeOptions> currentShapeOption =
      Rx<ShapeOptions>(ShapeOptions.circle);
  final Rx<DrawToolOptions> currentDrawToolOption =
      Rx<DrawToolOptions>(DrawToolOptions.pencil);

  RxString selectedAIModel = 'Griot'.obs;
  RxString selectedAIVoice = 'AI Tone'.obs;

  final RxList<String> aiModels = ['Griot', 'Alloy', 'Jarvis', 'Friday'].obs;
  final RxList<String> aiVoices =
      ['AI Tone', 'Friendly Tone', 'Formal Tone'].obs;

  final RxInt currentPageIndex = 1.obs;

  //====================

  // Canvas State
  final RxList<Stroke> strokes = <Stroke>[].obs;
  final Rx<Stroke?> currentStroke = Rxn<Stroke?>();
  final GlobalKey canvasGlobalKey = GlobalKey();
  final Rx<ui.Image?> backgroundImage = Rxn<ui.Image?>();

  // Undo/Redo
  final RxList<Stroke> _undoStack = <Stroke>[].obs;
  final RxList<Stroke> _redoStack = <Stroke>[].obs;

  final RxBool showCursor = false.obs;
  final Rx<Offset> cursorPosition = Offset.zero.obs;

  void updateCursorPosition(Offset position) {
    cursorPosition.value = position;
    showCursor.value = true;
  }

  void hideCursor() {
    showCursor.value = false;
  }

  // Drawing Actions
  void onPanStart(Offset startPoint) {
    if (selectedDrawingTool.value == DrawingTool.select) {
      _handleSelectionStart(startPoint);
    } else {
      currentStroke.value = Stroke(
        points: [startPoint],
        color: selectedDrawingTool.value == DrawingTool.eraser
            ? AppColors.canvasPrimaryColor
            : selectedColor.value,
        size: selectedDrawingTool.value == DrawingTool.eraser
            ? eraserSize.value
            : strokeSize.value,
        strokeType: selectedDrawingTool.value.strokeType,
      );
    }
    update();
  }

  void onPanUpdate(Offset newPoint) {
    if (selectedDrawingTool.value == DrawingTool.select &&
        _selectedStroke != null) {
      _handleStrokeMove(newPoint);
    } else if (currentStroke.value != null) {
      List<Offset> updatedPoints = List.from(currentStroke.value!.points)
        ..add(newPoint);
      currentStroke.value = Stroke(
        points: updatedPoints,
        color: currentStroke.value!.color,
        size: currentStroke.value!.size,
        strokeType: currentStroke.value!.strokeType,
      );
    }
    // print("up: ${currentStroke.value!.color}");
    update();
  }

  void onPanEnd() {
    if (selectedDrawingTool.value == DrawingTool.select) {
      _selectionStart = null;
      _selectedStroke = null;
    } else if (currentStroke.value != null) {
      strokes.add(Stroke(
        points: currentStroke.value!.points,
        color: currentStroke.value!.color,
        size: currentStroke.value!.size,
        strokeType: currentStroke.value!.strokeType,
      ));
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
    update();
  }

  void changeColor(Color newColor) {
    selectedColor.value = MaterialColor(newColor.value, const {});
  }

  Future<void> calculate([String? prompt]) async {
    isCalculating.value = true;
    try {
      // 1. Capture Image from Canvas
      final Uint8List? imageBytes = await _captureCanvasImage();
      if (imageBytes == null) {
        // Handle error: Canvas image capture failed
        Get.snackbar("Error", "Failed to capture canvas image",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      prompt ??=
          "Either solve the given problem if solvable or describe the image";

      await getResponse(prompt, imageBytes);
    } catch (e) {
      // Handle general errors
      print("error: $e");
    } finally {
      isCalculating.value = false;
    }
  }

  Future<Uint8List?> _captureCanvasImage() async {
    try {
      RenderRepaintBoundary boundary = canvasGlobalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error capturing canvas image: $e');
      return null;
    }
  }

  scrollToBottomChat() {
    try {
      chatScrollController
          .jumpTo(chatScrollController.position.maxScrollExtent);
    } catch (e) {
      print(e);
    }
  }

  // void chatbotGetResponse(String prompt) {
  //   isStreaming.value = true;
  //   try {
  //     chats.add(Content(role: 'user', parts: [
  //       Parts(text: prompt),
  //     ]));
  //     update();
  //     scrollToBottomChat();
  //     gemini.streamChat(chats).listen((value) {
  //       update();
  //       if (chats.isNotEmpty && chats.last.role == value.content?.role) {
  //         chats.last.parts!.last.text =
  //             '${chats.last.parts!.last.text}${value.output}';
  //       } else {
  //         chats.add(Content(role: 'model', parts: [Parts(text: value.output)]));
  //       }
  //     }, onDone: () {
  //       scrollToBottomChat();
  //       isStreaming.value = false;
  //     });
  //   } catch (e) {
  //     isStreaming.value = false;
  //     if (chats.last.role == 'user') {
  //       chats.removeLast();
  //     }
  //     Get.snackbar(
  //       'Error',
  //       'An error occurred please try again',
  //       snackPosition: SnackPosition.TOP,
  //       duration: const Duration(seconds: 3),
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  Future<void> getResponse(String prompt, [Uint8List? imageBytes]) async {
    isStreaming.value = true;
    try {
      // chats.add(Content("user", [TextPart(prompt)]));
      update();

      if (imageBytes != null) {
        chats.add(Content.data("image/png", imageBytes));
      }
      final chat = model.startChat(history: chats);
      await chat.sendMessage(Content.text(prompt));

      scrollToBottomChat();
      update();
    } catch (e) {
      print("Error: $e");
    } finally {
      isStreaming.value = false;
    }
  }

  //temp

  void _handleSelectionStart(Offset startPoint) {
    _selectionStart = startPoint;
    _selectedStroke = null;
    for (final stroke in strokes.reversed) {
      // Find a stroke to select
      final rect = _getStrokeRect(stroke);
      if (rect.contains(_selectionStart!)) {
        _selectedStroke = stroke;
        strokes.value = strokes.map((s) {
          return s == _selectedStroke
              ? s.copyWith(isSelected: true)
              : s.copyWith(isSelected: false);
        }).toList();
        break;
      }
    }
    update();
  }

  void _handleStrokeMove(Offset newPoint) {
    if (_selectionStart != null && _selectedStroke != null) {
      final delta = newPoint - _selectionStart!;
      strokes.value = strokes.map((s) {
        return s == _selectedStroke ? s.copyWith(offset: delta) : s;
      }).toList();
      _selectionStart = newPoint;
      update();
    }
  }

  Rect _getStrokeRect(Stroke stroke) {
    final minX =
        stroke.points.map((p) => p.dx + stroke.offset.dx).reduce(math.min);
    final maxX =
        stroke.points.map((p) => p.dx + stroke.offset.dx).reduce(math.max);
    final minY =
        stroke.points.map((p) => p.dy + stroke.offset.dy).reduce(math.min);
    final maxY =
        stroke.points.map((p) => p.dy + stroke.offset.dy).reduce(math.max);
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}
