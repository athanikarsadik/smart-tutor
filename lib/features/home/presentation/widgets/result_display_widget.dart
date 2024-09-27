import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../controller/home_controller.dart';
import 'chat_item_widget.dart';

class ResultsDisplay extends StatefulWidget {
  const ResultsDisplay({super.key});

  @override
  State<ResultsDisplay> createState() => _ResultsDisplayState();
}

class _ResultsDisplayState extends State<ResultsDisplay> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Obx(
        () => controller.chats.isEmpty
            ? const Center(
                child: Text(
                textAlign: TextAlign.center,
                "Hello Buddy!\nAsk me anything, I'm here to help you!",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
              ))
            : ListView.builder(
                itemCount: controller.chats.length,
                controller: controller.chatScrollController,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final Content content = controller.chats[index];
                  return ChatItemWidget(
                    content: content,
                  );
                }),
      );
    });
  }
}
