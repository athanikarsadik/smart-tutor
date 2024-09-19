import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_calculator/features/calculator/presentation/controller/calculator_controller.dart';
import 'package:smart_calculator/features/calculator/presentation/widgets/enter_prompt_widget.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/animated_drawer.dart';
import '../widgets/drawing_page.dart';
import '../widgets/result_display_widget.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = Get.find<CalculatorController>();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _solveTextController =
      TextEditingController(text: "Solve the following");

  @override
  void dispose() {
    _textController.dispose();
    _solveTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: controller.isExpanded.value ? 250.w : 60.w,
                child: Drawer(
                  backgroundColor: AppColors.primaryColor,
                  elevation: 2,
                  child: CalculatorDrawerAni(),
                ),
              ),
            ),
            SizedBox(
              width: 0.01.sw,
            ),
            Expanded(
              flex: 9,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 0.08.sh,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5.r,
                                  blurRadius: 7.r,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: EnterPromptWidget(
                              textEditingController: _solveTextController,
                              isSolve: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                var prompt = _solveTextController.text.trim();
                                if (prompt.isEmpty) {
                                  prompt = "?";
                                }
                                controller.calculate(prompt);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 5.r,
                                      blurRadius: 7.r,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Solve",
                                    style: TextStyle(
                                        color: AppColors.canvasBgColor,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const Expanded(flex: 12, child: DrawingPage()),
                ],
              ),
            ),
            SizedBox(
              width: 0.01.sw,
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                    flex: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5.r,
                            blurRadius: 7.r,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const ResultsDisplay(),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Container(
                            height: 0.08.sh,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5.r,
                                  blurRadius: 7.r,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: EnterPromptWidget(
                              textEditingController: _textController,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              final prompt = _textController.text.trim();
                              _textController.clear();
                              if (prompt.isNotEmpty &&
                                  !controller.isStreaming.value) {
                                // controller.chatbotGetResponse(prompt);
                                controller.getResponse(prompt);
                              }
                            },
                            child: Obx(
                              () => Container(
                                height: 0.08.sh,
                                decoration: BoxDecoration(
                                  color: AppColors.buttonColor,
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 5.r,
                                      blurRadius: 7.r,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: controller.isStreaming.value
                                    ? Lottie.asset('assets/lottie/loading.json',
                                        width: 120.w, height: 80.h)
                                    : Icon(
                                        Icons.send,
                                        color: AppColors.whiteColor,
                                        size: 25.sp,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 0.01.sw,
            ),
          ],
        ),
      ),
    );
  }
}
