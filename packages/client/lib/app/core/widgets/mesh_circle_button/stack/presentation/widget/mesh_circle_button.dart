import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:primala/app/core/widgets/mesh_circle_button/stack/presentation/presentation.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:primala/app/core/widgets/mesh_circle_button/stack/presentation/widget/canvas/mesh_circle_painter.dart';
import 'package:primala/app/core/widgets/shared/constants/svg_animation_constants.dart';

class MeshCircleButton extends StatelessWidget {
  final MeshCircleButtonStore trackerStore;
  final Size size;
  const MeshCircleButton({
    super.key,
    required this.trackerStore,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        painter: MeshCirclePainter(SvgAnimtionCostants.circlePath, size,
            firstGradientColor: Colors.white,
            secondGradientColor: Colors.white),
        child: ClipPath(
          clipper: CustomPathClipper(SvgAnimtionCostants.circlePath),
          child: AnimatedMeshGradient(
            colors: const [
              // 00
              Color(0xFF88F4FC),
              Color(0xFF0BB7FC),
              Color(0xFF6FE6C9),
              Color(0xFF67EEAC),
            ],
            options: AnimatedMeshGradientOptions(),
          ),
        ),
      ),
    );
  }
}

class CustomPathClipper extends CustomClipper<Path> {
  final Path customClipPath;

  CustomPathClipper(this.customClipPath);

  @override
  Path getClip(Size size) {
    return customClipPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
