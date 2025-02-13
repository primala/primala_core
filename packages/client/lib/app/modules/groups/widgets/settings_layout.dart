import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/types/types.dart';

class SettingsLayout extends HookWidget with DialogueUtils {
  final Function onDeleteAccount;
  final UserEntity user;
  final bool canDeleteAccount;
  const SettingsLayout({
    super.key,
    required this.onDeleteAccount,
    required this.user,
    required this.canDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState<bool>(false);
    // Add animation controller
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );
    // Create rotation animation
    final rotationAnimation = Tween<double>(
      begin: 0,
      end: 90,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    return Observer(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: UserAvatar(
                fullName: user.fullName,
                gradient: user.profileGradient,
                size: 100,
                fontSize: 40,
              ),
            ),
            Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: user.fullName,
                  hintStyle: GoogleFonts.jost(color: Colors.white),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.black.withOpacity(.6),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Jost(
              user.email,
              fontSize: 16,
              fontColor: Colors.black.withOpacity(.6),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 30.0,
              ),
              child: Divider(
                color: Colors.black,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
            ),
            Padding(
              // ignore: prefer_const_constructors
              padding: EdgeInsets.only(left: 16),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Jost(
                  'Account',
                  fontSize: 20,
                  fontColor: Colors.black,
                ),
              ),
            ),
            ExpansionTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Jost(
                  'Delete Account',
                  fontSize: 18,
                  fontColor: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
              backgroundColor: Colors.transparent,
              collapsedIconColor: Colors.black,
              iconColor: Colors.black38,
              trailing: AnimatedBuilder(
                animation: rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: rotationAnimation.value *
                        3.14159 /
                        180, // Convert degrees to radians
                    child: const Icon(
                      CupertinoIcons.chevron_right,
                      color: Colors.black,
                    ),
                  );
                },
              ),
              onExpansionChanged: (expanded) {
                isExpanded.value = expanded;
                if (expanded) {
                  animationController.forward();
                } else {
                  animationController.reverse();
                }
              },
              expandedAlignment: canDeleteAccount
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              children: [
                if (canDeleteAccount)
                  Padding(
                    padding: const EdgeInsets.only(right: 28),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        backgroundColor: NokhteColors.red,
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () => showDeleteConfirmationDialog(
                        context: context,
                        onConfirm: onDeleteAccount,
                        title: 'Delete Account',
                        content:
                            'This action is permanent and cannot be undone. All your data, settings, and preferences will be irreversibly deleted.',
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Jost(
                          'Delete',
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          fontColor: NokhteColors.eggshell,
                        ),
                      ),
                    ),
                  ),
                if (!canDeleteAccount)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Jost(
                      'You must leave or delete all groups before deleting your account.',
                      fontSize: 12,
                      softWrap: true,
                      fontWeight: FontWeight.w300,
                      fontColor: Colors.black.withOpacity(.6),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
