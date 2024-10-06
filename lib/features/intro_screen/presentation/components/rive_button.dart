import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';

class RiveButtonAnimation extends StatefulWidget {
  const RiveButtonAnimation({Key? key}) : super(key: key);

  @override
  State<RiveButtonAnimation> createState() => _RiveButtonAnimationState();
}

class _RiveButtonAnimationState extends State<RiveButtonAnimation> {
  StateMachineController? _controller;
  SMIInput<bool>? _hoverInput;

  void _onRiveInit(Artboard artboard) {
    _controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (_controller != null) {
      artboard.addController(_controller!);
      _hoverInput = _controller!.findInput<bool>('Hover');
      if (_hoverInput == null) {
        debugPrint(
            'Warning: Unable to find "Hover" input in the state machine.');
      }
    } else {
      debugPrint('Warning: Unable to initialize StateMachineController.');
    }
  }

  void _onHoverStart(PointerEvent event) {
    _hoverInput?.value = true;
  }

  void _onHoverEnd(PointerEvent event) {
    _hoverInput?.value = false;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        onEnter: _onHoverStart,
        onExit: _onHoverEnd,
        child: SizedBox(
          width: 500.w,
          height: 500.h,
          child: RiveAnimation.asset(
            'rive/button_animation.riv',
            fit: BoxFit.cover,
            onInit: _onRiveInit,
          ),
        ),
      ),
    );
  }
}
