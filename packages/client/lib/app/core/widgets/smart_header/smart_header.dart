// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class SmartHeader extends HookWidget {
  final String content;
  final Color color;
  const SmartHeader({
    super.key,
    required this.content,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Jost(
      content,
      fontSize: 40,
      shouldCenter: true,
      fontColor: color,
    );
  }
}
