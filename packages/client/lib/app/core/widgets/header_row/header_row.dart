import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';

class HeaderRow extends HookWidget {
  final List<Widget> children;

  const HeaderRow({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = useFullScreenSize().height;
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * .1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}
