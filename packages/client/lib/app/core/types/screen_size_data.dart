import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ScreenSizeData extends Equatable {
  final double height;
  final double width;
  final Size size;
  final EdgeInsets padding;

  ScreenSizeData({
    required this.height,
    required this.width,
    required this.padding,
  }) : size = Size(width, height);

  static zero() =>
      ScreenSizeData(height: 0.0, width: 0.0, padding: EdgeInsets.zero);

  @override
  List<Object> get props => [height, width, padding];
}
