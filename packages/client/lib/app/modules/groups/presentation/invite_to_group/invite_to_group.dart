import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/groups.dart';
export 'invite_to_group_coordinator.dart';

class InviteToGroupScreen extends HookWidget {
  final InviteToGroupCoordinator coordinator;
  final GroupEntity group;
  const InviteToGroupScreen({
    super.key,
    required this.coordinator,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor(group);
      return () => coordinator.dispose();
    }, []);
    return Observer(builder: (context) {
      return AnimatedScaffold(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TitleBar(
            centerTextLabel: 'Invite to Group',
            rightTextLabel: 'Invite',
            onCancelTapped: coordinator.onGoBack,
            onConfirmTapped: () async => await coordinator.sendInvitations(),
          ),
          InvitationBody(
            store: coordinator.invitationBody,
          ),
        ],
      );
    });
  }
}
