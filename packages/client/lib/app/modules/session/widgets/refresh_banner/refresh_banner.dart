import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

import 'refresh_banner.dart';
export 'refresh_banner_store.dart';
export 'refresh_banner.dart';

class RefreshBanner extends HookWidget {
  final RefreshBannerStore store;
  const RefreshBanner({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final size = useScaledSize(
      baseValue: .07,
      screenSize: useFullScreenSize(),
      bumpPerHundredth: 0.0001,
    );
    return Observer(
      builder: (context) {
        return AnimatedOpacity(
          opacity: useWidgetOpacity(store.showWidget),
          duration: Seconds.get(1),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size),
                child: Center(
                  child: Jost(
                    "Swipe down to pause",
                    fontSize: size * .3,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size * .06),
                child: Image.asset(
                  'assets/rounded_triangle.png',
                  width: size * .4,
                  height: size * .4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RoundedTriangle extends StatelessWidget {
  final double size;
  final Color color;
  final double borderRadius;

  const RoundedTriangle({
    super.key,
    this.size = 100,
    this.color = Colors.blue,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipPath(
        clipper: _RoundedTriangleClipper(borderRadius),
        child: Container(
          color: color,
        ),
      ),
    );
  }
}

class _RoundedTriangleClipper extends CustomClipper<Path> {
  final double radius;

  _RoundedTriangleClipper(this.radius);

  @override
  Path getClip(Size size) {
    final path = Path();

    // Define the points of the triangle
    final point1 = Offset(size.width / 2, 0);
    final point2 = Offset(0, size.height);
    final point3 = Offset(size.width, size.height);

    // Move to top center
    path.moveTo(point1.dx, point1.dy + radius);

    // Draw line to bottom left with rounded corner
    path.lineTo(point2.dx + radius, point2.dy - radius);
    path.arcToPoint(
      Offset(point2.dx + radius, point2.dy),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    // Draw line to bottom right with rounded corner
    path.lineTo(point3.dx - radius, point3.dy);
    path.arcToPoint(
      Offset(point3.dx - radius, point3.dy - radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    // Draw line back to top with rounded corner
    path.lineTo(point1.dx + radius, point1.dy + radius);
    path.arcToPoint(
      Offset(point1.dx - radius, point1.dy + radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    // Close the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
