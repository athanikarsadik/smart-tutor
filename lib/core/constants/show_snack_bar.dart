import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showSnackBar({
  required ToastificationType type,
  required String msg,
}) {
  toastification.show(
    type: type,
    style: ToastificationStyle.flatColored,
    title: Text(msg),
    alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 3),
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
    pauseOnHover: true,
    applyBlurEffect: true,
    closeOnClick: true,
    borderRadius: BorderRadius.circular(12.0),
    closeButtonShowType: CloseButtonShowType.none,
    dragToClose: true,
  );
}
