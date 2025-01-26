import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'invitation_body_store.dart';

class InvitationBody extends HookWidget {
  final InvitationBodyStore invitationBodyStore;

  const InvitationBody({
    super.key,
    required this.invitationBodyStore,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      // text field here
      // permission level menu item here
      // selection component goes here
    ]);
  }
}
