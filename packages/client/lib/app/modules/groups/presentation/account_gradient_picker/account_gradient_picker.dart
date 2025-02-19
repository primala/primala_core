import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/types/types.dart';

class AccountGradientPickerScreen extends HookWidget {
  final Function(ProfileGradient) onGradientTapped;
  final UserEntity user;

  const AccountGradientPickerScreen({
    super.key,
    required this.onGradientTapped,
    required this.user,
  });

  @override
  Widget build(context) {
    return AnimatedScaffold(
      children: [
        HeaderRow(
          title: "User Icon",
          onChevronTapped: () => Modular.to.pop(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 20),
          child: UserAvatar(
            fullName: user.fullName,
            gradient: user.profileGradient,
            size: 100,
            fontSize: 40,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          // mainAxisAlignment: MainAxisAlignment.center,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 1,
          ),
          itemCount:
              ProfileGradient.values.length - 1, // Exclude the 'none' option
          itemBuilder: (context, index) {
            final gradient = ProfileGradient.values[index];
            if (gradient == ProfileGradient.none) {
              return const SizedBox.shrink();
            }
            return Center(
              child: GestureDetector(
                onTap: () async => await onGradientTapped(gradient),
                child: UserAvatar(
                  fullName: user.fullName,
                  gradient: gradient,
                  size: 70,
                  fontSize: 30,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
