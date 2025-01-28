import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/types/types.dart';

class GroupAvatar extends HookWidget with NokhteGradients {
  final Function? onPencilTap;
  final String groupName;
  final ProfileGradient profileGradient;
  final double size;
  GroupAvatar({
    super.key,
    required this.groupName,
    this.onPencilTap,
    this.size = 123,
    required this.profileGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: mapProfileGradientToLinearGradient(
            profileGradient == ProfileGradient.none
                ? NokhteGradients.getRandomGradient()
                : profileGradient,
          ),
        ),
        child: MultiHitStack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Jost(
                groupName.isEmpty
                    ? ""
                    : groupName.characters.first.toUpperCase(),
                fontSize: 54,
                // fontWeight: FontWeight.w300,
                shouldCenter: true,
                // addShadow: true,
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
        ));
  }
}
