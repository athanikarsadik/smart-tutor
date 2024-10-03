import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
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
    ever(_homeController.newChats, (_) {
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
    return Obx(
      () => SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _homeController.newChats.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: Get.height / 4.5,
                        ),
                        SvgPicture.asset(
                          "assets/svg/logo_icon.svg",
                          height: 80.sp,
                          width: 80.sp,
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
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Obx(
                    () => ListView.builder(
                      itemCount: _homeController.newChats.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final content = _homeController.newChats[index];
                        return ChatItemWidget(
                          content: content,
                          userWidth: widget.userWidth,
                        );
                      },
                    ),
                  ),
            if (_homeController.isStreaming.value)
              _buildShimmerBelowLastItem(context, _homeController),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerBelowLastItem(
      BuildContext context, HomeController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        final listViewHeight = constraints.maxHeight;
        final lastItemPosition = listViewHeight - 50.h;

        return Positioned(
          left: 0,
          top: lastItemPosition,
          child: _buildGradientShimmer(),
        );
      },
    );
  }

  Widget _buildGradientShimmer() {
    return SizedBox(
        height: 100.h,
        child: Shimmer.fromColors(
          baseColor: AppColors.canvasButtonColor,
          highlightColor: AppColors.canvasPrimaryColor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildShimmerLine(),
                  SizedBox(height: 8.h),
                  _buildShimmerLine(),
                  SizedBox(height: 8.h),
                  _buildShimmerLine(),
                  SizedBox(height: 8.h),
                  _buildShimmerLine(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildShimmerLine() {
    return Container(
      width: double.maxFinite,
      height: 15.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5.r),
      ),
    );
  }
}
