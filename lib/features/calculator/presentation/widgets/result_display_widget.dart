import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../controller/calculator_controller.dart';
import 'chat_item_widget.dart';

class ResultsDisplay extends StatefulWidget {
  const ResultsDisplay({super.key});

  @override
  State<ResultsDisplay> createState() => _ResultsDisplayState();
}

class _ResultsDisplayState extends State<ResultsDisplay> {
  final CalculatorController _controller = Get.find<CalculatorController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalculatorController>(builder: (_) {
      return Obx(
        () => _controller.chats.isEmpty
            ? const Center(
                child: Text(
                textAlign: TextAlign.center,
                "Hello Buddy!\nAsk me anything, I'm here to help you!",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
              ))
            : ListView.builder(
                itemCount: _controller.chats.length,
                controller: _controller.chatScrollController,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _controller.scrollToBottomChat());
                  final Content content = _controller.chats[index];
                  return ChatItemWidget(
                    content: content,
                  );
                }),
      );
    });
  }
}
