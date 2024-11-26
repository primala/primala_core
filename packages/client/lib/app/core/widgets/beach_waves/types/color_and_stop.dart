import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'gradient_config.dart';

class ColorAndStop extends Equatable {
  final Color color;
  final double stop;
  const ColorAndStop(this.color, this.stop);

  @override
  List<Object> get props => [color, stop];

  static GradientConfig toGradientConfig(List<ColorAndStop> colorAndStops) {
    final colors = colorAndStops.map((e) => e.color).toList();
    final stops = colorAndStops.map((e) => e.stop).toList();
    return GradientConfig(colors: colors, stops: stops);
  }
}
