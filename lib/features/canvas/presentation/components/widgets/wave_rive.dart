import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

enum AnimationState { idle, inn, active, out }

class RiveWaveBackground extends StatefulWidget {
  final String assetPath;
  final BoxFit fit;
  final bool autoPlay; // Add this parameter
  final Duration animationDuration;

  const RiveWaveBackground({
    Key? key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.autoPlay = false, // Default to false
    this.animationDuration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  State<RiveWaveBackground> createState() => RiveWaveBackgroundState();
}

class RiveWaveBackgroundState extends State<RiveWaveBackground> {
  StateMachineController? _controller;
  SMITrigger? _inTrigger;
  SMITrigger? _outTrigger;
  SMIBool? _activeBool;
  Timer? _animationTimer;
  AnimationState _currentState = AnimationState.idle;

  void _onRiveInit(Artboard artboard) {
    _controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (_controller != null) {
      artboard.addController(_controller!);
      _inTrigger = _controller!.findInput<bool>('in') as SMITrigger?;
      _outTrigger = _controller!.findInput<bool>('out') as SMITrigger?;
      _activeBool = _controller!.findInput<bool>('active') as SMIBool?;

      if (_inTrigger == null || _outTrigger == null || _activeBool == null) {
        debugPrint('Warning: Some inputs were not found in the state machine.');
      }
      // if (widget.onInitComplete != null) {
      //   widget.onInitComplete!();
      // }
    } else {
      debugPrint('Unable to initialize StateMachineController');
    }
  }

  void setAnimationState(AnimationState state) {
    if (_controller == null) return; // Handle null controller
    switch (state) {
      case AnimationState.idle:
        _activeBool?.value = false;
        break;
      case AnimationState.inn:
        _inTrigger?.fire();
        break;
      case AnimationState.active:
        _activeBool?.value = true;
        break;
      case AnimationState.out:
        _outTrigger?.fire();
        break;
    }
  }

  void _startAnimationLoop() {
    _animationTimer = Timer.periodic(widget.animationDuration, (timer) {
      setState(() {
        switch (_currentState) {
          case AnimationState.idle:
            _currentState = AnimationState.inn;
            break;
          case AnimationState.inn:
            _currentState = AnimationState.active;
            break;
          case AnimationState.active:
            _currentState = AnimationState.out;
            break;
          case AnimationState.out:
            _currentState = AnimationState.idle; // Back to idle
            break;
        }
        setAnimationState(_currentState);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) {
      _startAnimationLoop();
    }
  }

  @override
  void didUpdateWidget(RiveWaveBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoPlay != oldWidget.autoPlay) {
      if (widget.autoPlay) {
        _startAnimationLoop();
      } else {
        _animationTimer?.cancel();
        _animationTimer = null;
      }
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Or adjust as needed
      child: RiveAnimation.asset(
        widget.assetPath,
        fit: widget.fit,
        onInit: _onRiveInit,
      ),
    );
  }
}
