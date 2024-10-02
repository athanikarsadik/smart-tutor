import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

void showSnackBar(BuildContext context) {
  toastification.show(
    type: ToastificationType.info,
    style: ToastificationStyle.flatColored,
    title: const Text("Copied to Clipboard"),
    alignment: Alignment.topLeft,
    autoCloseDuration: const Duration(seconds: 2),
    animationBuilder: (
      context,
      animation,
      alignment,
      child,
    ) {
      return ScaleTransition(
        scale: animation,
        child: child,
      );
    },
    icon: Icon(Icons.copy_outlined),
    borderRadius: BorderRadius.circular(12.0),
    closeButtonShowType: CloseButtonShowType.none,
    dragToClose: true,
  );
}
