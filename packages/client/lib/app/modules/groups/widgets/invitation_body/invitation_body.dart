import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'invitation_body_store.dart';
export 'invitation_text_field.dart';
export 'invitation_permission_level.dart';

class InvitationBody extends HookWidget {
  final InvitationBodyStore store;

  const InvitationBody({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Extended Email TextField
            InvitationTextField(
              controller: store.controller,
              onChange: store.onChange,
            ),
            InvitationPermissionLevel(
              onCurrentPermissionTapped: store.onPermissionLevelTap,
              currentRole: store.currentRole,
            ),
            // Add permission dropdown here later
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28, bottom: 8),
              child: Jost(
                store.selectAreaTitleText,
                fontSize: 15,
                fontColor: Colors.black.withOpacity(.6),
              ),
            ),
            // Selectable Email Tag
          ],
        ),
      );
    });
  }
}
