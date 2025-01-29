import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/types/types.dart';

class UserAvatar extends HookWidget with NokhteGradients {
  final String fullName;
  final ProfileGradient gradient;
  final double size;

  const UserAvatar({
    super.key,
    required this.fullName,
    required this.gradient,
    required this.size,
  });

  getInitials(String fullName) {
    if (fullName.isNotEmpty) {
      final names = fullName.split(' ');
      final initials = names.map((name) => name[0]).join('');
      return initials.toUpperCase();
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: mapProfileGradientToLinearGradient(
          gradient,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Center(
          child: Jost(
            getInitials(fullName),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            shouldCenter: true,
          ),
        ),
      ),
    );
  }
}
