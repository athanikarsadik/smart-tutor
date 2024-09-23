import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socratica/core/constants/asset_strings.dart';

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
  bool _isDrawerOpen = true;
  bool _isChatOpen = true;
  bool _isChatSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasPrimaryColor,
      body: Stack(
        children: [
          const CanvasWidget(),
          Positioned(
            left: 30.w,
            top: 20.h,
            child: Row(
              children: [
                AnimatedIconButton(
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
                  iconPath: AssetStrings.menuSvg,
                ),
                SizedBox(
                  width: 15.w,
                ),
                AnimatedIconButton(
                  width: 55.sp,
                  height: 55.sp,
                  callbackAction: () {},
                  padding: EdgeInsets.all(20.sp),
                  backgroundColor: AppColors.canvasSecondaryColor,
                  shadowColor: AppColors.blackColor.withOpacity(0.25),
                  iconPath: AssetStrings.undoSvg,
                ),
                SizedBox(
                  width: 15.w,
                ),
                AnimatedIconButton(
                  width: 55.sp,
                  height: 55.sp,
                  callbackAction: () {},
                  padding: EdgeInsets.all(20.sp),
                  backgroundColor: AppColors.canvasSecondaryColor,
                  shadowColor: AppColors.blackColor.withOpacity(0.25),
                  iconPath: AssetStrings.redoSvg,
                ),
              ],
            ),
          ),
          Positioned(
            left: 30.w,
            top: 150.h,
            child: AnimatedDrawer(
              isOpen: _isDrawerOpen,
              onToggle: () => setState(() => _isDrawerOpen = !_isDrawerOpen),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: FloatingOptionBar(),
          ),
          if (_isChatOpen)
            Positioned(
              top: 0.h,
              right: 0,
              bottom: 20,
              child: ChatWindow(
                isChat: _isChatSelected,
                onChatIconTap: () => setState(() {
                  _isChatSelected = !_isChatSelected;
                }),
                onClose: () => setState(() => _isChatOpen = !_isChatOpen),
              ),
            ),
          Positioned(
            bottom: 30.h,
            left: 30.w,
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
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 25.sp,
                      )),
                  Text(
                    "01",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: AppColors.whiteColor),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 25.sp,
                      )),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: !_isChatOpen
          ? FloatingActionButton(
              backgroundColor: AppColors.canvasButtonColor,
              child: SvgPicture.asset(
                AssetStrings.chatSvg,
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
