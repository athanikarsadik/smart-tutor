import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:socrita/features/canvas/presentation/controllers/home_controller.dart';
import 'package:socrita/features/canvas/presentation/components/widgets/chat_item_widget.dart';

class ResultsDisplay extends StatefulWidget {
  final double userWidth;
  const ResultsDisplay({super.key, this.userWidth = 0.25});

  @override
  State<ResultsDisplay> createState() => _ResultsDisplayState();
}

class _ResultsDisplayState extends State<ResultsDisplay> {
  final ScrollController _scrollController = ScrollController();
  final HomeController _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
    ever(_homeController.chats, (_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Obx(
          () => controller.chats.isEmpty
              ? const Center(
                  child: Text(
                    "Hello Buddy!\nAsk me anything, I'm here to help you!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w700),
                  ),
                )
              : ListView.builder(
                  itemCount: controller.chats.length,
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final content = controller.chats[index];
                    return ChatItemWidget(
                      content: content,
                      userWidth: widget.userWidth,
                    );
                  },
                ),
        );
      },
    );
  }
}
