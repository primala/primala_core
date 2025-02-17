import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/types/types.dart';

class UserAvatar extends HookWidget with NokhteGradients {
  final String fullName;
  final ProfileGradient gradient;
  final double size;
  final double fontSize;
  final Function()? onXTap;
  final Function? onPencilTap;

  const UserAvatar({
    super.key,
    required this.fullName,
    required this.gradient,
    required this.size,
    this.onXTap,
    this.fontSize = 16,
    this.onPencilTap,
  });

  String getInitials(String fullName) {
    if (fullName.isEmpty) {
      return '';
    }

    final names =
        fullName.trim().split(' ').where((name) => name.isNotEmpty).toList();

    if (names.isEmpty) {
      return '';
    } else if (names.length == 1) {
      return names[0][0].toUpperCase();
    } else {
      final firstInitial = names.first[0];
      final lastInitial = names.last[0];
      return (firstInitial + lastInitial).toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiHitStack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: mapProfileGradientToLinearGradient(
              gradient,
            ),
          ),
          child: Center(
            child: Jost(
              getInitials(fullName),
              fontSize: fontSize,
              fontColor: Colors.white,
              fontWeight: FontWeight.w400,
              shouldCenter: true,
            ),
          ),
        ),
        if (onXTap != null)
          Positioned(
            top: -5,
            right: -5,
            child: Blur(
              blurColor: Colors.black,
              colorOpacity: .6,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        if (onXTap != null)
          Positioned(
            top: -5,
            right: -5,
            child: GestureDetector(
              onTap: () => onXTap?.call(),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (onPencilTap != null)
          Positioned(
            right: 5,
            bottom: 0,
            child: GestureDetector(
              onTap: () => onPencilTap?.call(),
              child: Container(
                height: size * .27,
                width: size * .27,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.09),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Blur(
                        borderRadius: BorderRadius.circular(20),
                        blurColor: Colors.white,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Center(
                        child: Image.asset(
                          'assets/groups/pencil_icon_black.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}
