import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:socratica/core/constants/asset_strings.dart';
import 'package:socratica/features/canvas/presentation/controllers/home_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../components/canvas.dart';
import '../components/chat_window.dart';
import '../components/drawer.dart';
import '../components/floating_action_bar.dart';
import '../components/widgets/animated_button.dart';

class DrawingApp extends StatefulWidget {
  const DrawingApp({super.key});

  @override
  State<DrawingApp> createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  bool _isDrawerOpen = false;
  bool _isChatOpen = true;

  @override
  Widget build(BuildContext context) {
    bool isDesktopWeb = kIsWeb && MediaQuery.of(context).size.width > 800;
    return Scaffold(
      backgroundColor: AppColors.canvasPrimaryColor,
      body: isDesktopWeb
          ? Padding(
              padding: EdgeInsets.all(20.sp),
              child: Stack(
                children: [
                  //canvas widget
                  const CanvasWidget(),

                  //top left option buttons
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        AnimatedIconButton(
                          message: "Menu",
                          width: 55.sp,
                          height: 55.sp,
                          callbackAction: () {
                            setState(() {
                              _isDrawerOpen = !_isDrawerOpen;
                            });
                          },
                          padding: EdgeInsets.all(20.sp),
                          backgroundColor: AppColors.canvasSecondaryColor,
                          shadowColor: AppColors.blackColor.withOpacity(0.25),
                          iconPath: "assets/svg/menu.svg",
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        AnimatedIconButton(
                          width: 55.sp,
                          message: "Undo",
                          height: 55.sp,
                          callbackAction: () {
                            Get.find<HomeController>().undo();
                          },
                          padding: EdgeInsets.all(20.sp),
                          backgroundColor: AppColors.canvasSecondaryColor,
                          shadowColor: AppColors.blackColor.withOpacity(0.25),
                          iconPath: "assets/svg/undo.svg",
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        AnimatedIconButton(
                          message: "Redo",
                          width: 55.sp,
                          height: 55.sp,
                          callbackAction: () {
                            Get.find<HomeController>().redo();
                          },
                          padding: EdgeInsets.all(20.sp),
                          backgroundColor: AppColors.canvasSecondaryColor,
                          shadowColor: AppColors.blackColor.withOpacity(0.25),
                          iconPath: "assets/svg/redo.svg",
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        AnimatedIconButton(
                          message: "Reset the canvas",
                          width: 55.sp,
                          height: 55.sp,
                          callbackAction: () {
                            Get.find<HomeController>().clear();
                          },
                          padding: EdgeInsets.all(20.sp),
                          backgroundColor: AppColors.canvasSecondaryColor,
                          shadowColor: AppColors.blackColor.withOpacity(0.25),
                          iconPath: "assets/svg/reset.svg",
                          colorFilter: const ColorFilter.mode(
                              Colors.red, BlendMode.srcIn),
                        ),
                      ],
                    ),
                  ),

                  //drawer
                  Positioned(
                    top: 100.h,
                    child: AnimatedDrawer(
                      isOpen: _isDrawerOpen,
                      onToggle: () =>
                          setState(() => _isDrawerOpen = !_isDrawerOpen),
                    ),
                  ),

                  //floating option bar
                  Align(
                    alignment: Alignment.topCenter,
                    child: FloatingOptionBar(),
                  ),
                  if (_isChatOpen)
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 20,
                      child: ChatWindow(
                        onChatIconTap: () =>
                            Get.find<HomeController>().isChatDialog.value =
                                !Get.find<HomeController>().isChatDialog.value,
                        onClose: () =>
                            setState(() => _isChatOpen = !_isChatOpen),
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: 140.sp,
                      height: 55.sp,
                      decoration: BoxDecoration(
                          color: AppColors.canvasSecondaryColor,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: AppColors.canvasBorderColor, width: 0.2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              iconSize: 25.sp,
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 20.sp,
                              )),
                          Text(
                            "01",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: AppColors.whiteColor),
                          ),
                          IconButton(
                              iconSize: 25.sp,
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20.sp,
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: EdgeInsets.all(16.0.sp),
                child: Text(
                  'This application is designed for desktop web. Please open it on a desktop browser.',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 18.sp, color: AppColors.whiteColor),
                ),
              ),
            ),
      floatingActionButton: !_isChatOpen
          ? FloatingActionButton(
              backgroundColor: AppColors.canvasButtonColor,
              child: SvgPicture.asset(
                "assets/svg/chat.svg",
                height: 30.sp,
              ),
              onPressed: () {
                _isChatOpen = !_isChatOpen;
                setState(() {});
              })
          : const SizedBox.shrink(),
    );
  }
}
