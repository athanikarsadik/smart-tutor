import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:socrita/core/theme/app_colors.dart';
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
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.amberAccent,
                        size: 40.sp,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "\"Knowledge is a journey of inquiry. \nWhat wonders do you wish to explore?\"",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                          fontSize: 22.sp,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              blurRadius: 10.r,
                              color: Colors.black38,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
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
