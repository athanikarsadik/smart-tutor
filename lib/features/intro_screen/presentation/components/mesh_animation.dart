import 'package:flutter/material.dart';
import 'package:mesh/mesh.dart';

class MeshAnimation extends StatefulWidget {
  const MeshAnimation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MeshAnimationState createState() => _MeshAnimationState();
}

class _MeshAnimationState extends State<MeshAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat(reverse: true);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final dt = controller.value;
          return OMeshGradient(
            tessellation: 12,
            size: Size.infinite,
            mesh: OMeshRect(
              width: 3,
              height: 4,
              colorSpace: OMeshColorSpace.lab,
              fallbackColor: Colors.transparent,
              vertices: [
                (0.0, 0.3).v.to((0.0, 0.0).v, dt),
                (0.5, 0.15).v.to((0.5, 0.1).v, dt * dt),
                (1.0, -0.1).v.to((1.0, 0.3).v, dt * dt),
                (-0.05, 0.68).v.to((0.0, 0.45).v, dt),
                (0.63, 0.3).v.to((0.48, 0.54).v, dt),
                (1.0, 0.1).v.to((1.0, 0.6).v, dt),
                (-0.2, 0.92).v.to((0.0, 0.58).v, dt),
                (0.32, 0.72).v.to((0.58, 0.69).v, dt * dt),
                (1.0, 0.3).v.to((1.0, 0.8).v, dt),
                (0.0, 1.2).v.to((0.0, 0.86).v, dt),
                (0.5, 0.88).v.to((0.5, 0.95).v, dt),
                (1.0, 0.82).v.to((1.0, 1.0).v, dt),
              ],
              colors: [
                null,
                null,
                null,
                Color.lerp(Colors.orange[500]?.withOpacity(0.8),
                    const Color.fromARGB(255, 10, 33, 122), dt),
                Color.lerp(Colors.orange[200]?.withOpacity(0.8),
                    const Color.fromARGB(252, 103, 48, 205), dt),
                Color.lerp(Colors.orange[400]?.withOpacity(0.90),
                    const Color.fromARGB(252, 103, 53, 128), dt),
                Color.lerp(Colors.orange[900],
                    const Color.fromARGB(225, 9, 20, 109), dt),
                Color.lerp(Colors.orange[800]?.withOpacity(0.98),
                    const Color.fromARGB(255, 103, 48, 205), dt),
                Color.lerp(Colors.orange[900],
                    const Color.fromARGB(255, 83, 0, 124), dt),
                null,
                null,
                null,
              ],
            ),
          );
        },
      ),
    );
  }
}

extension on OVertex {
  OVertex to(OVertex b, double t) => lerpTo(b, t);
}
