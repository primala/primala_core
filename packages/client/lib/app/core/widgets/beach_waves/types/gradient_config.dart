import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GradientConfig {
  final List<Color> colors;
  final List<double> stops;

  const GradientConfig({
    required this.colors,
    required this.stops,
  }) : assert(colors.length == stops.length,
            'Colors and stops must have the same length');

  factory GradientConfig.empty() => GradientConfig(colors: [], stops: []);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradientConfig &&
          listEquals(colors, other.colors) &&
          listEquals(stops, other.stops);

  @override
  int get hashCode => Object.hash(colors, stops);
}
