import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class InvitationPermissionLevel extends StatelessWidget {
  final Function onCurrentPermissionTapped;
  final String currentRole;
  const InvitationPermissionLevel({
    super.key,
    required this.onCurrentPermissionTapped,
    required this.currentRole,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 28, bottom: 8),
          child: Jost(
            'Permission level',
            fontSize: 15,
            fontColor: Colors.black.withOpacity(.6),
          ),
        ),
        GenericMenuItem(
          onTap: () {
            onCurrentPermissionTapped();
          },
          title: currentRole,
          borderColor: Colors.black.withOpacity(.2),
          showChevron: true,
          padding: const EdgeInsets.only(
            left: 35,
            top: 7,
            bottom: 7,
          ),
        ),
      ],
    );
  }
}
