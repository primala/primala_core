import 'package:flutter/material.dart';

mixin SwipeableTileConstants {
  final Curve kResizeTimeCurve = const Interval(0.4, 1.0, curve: Curves.ease);
  final double kMinFlingVelocity = 700.0;
  final double kMinFlingVelocityDelta = 400.0;
  final double kFlingVelocityScale = 1.0 / 300.0;
}
