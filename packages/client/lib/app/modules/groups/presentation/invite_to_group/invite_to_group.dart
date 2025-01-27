import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'invite_to_group_coordinator.dart';
export 'invite_to_group_widgets_coordinator.dart';

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
      return null;
      // return () => coordinator.deconstructor();
    }, []);
    return Observer(builder: (context) {
      return AnimatedScaffold(
        store: coordinator.widgets.animatedScaffold,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TitleBar(
              centerTextLabel: 'Invite to Group',
              rightTextLabel: 'Invite',
              onCancelTapped: () => Modular.to.pop(),
              onConfirmTapped: () {},
            ),
            InvitationBody(
              store: coordinator.widgets.invitationBody,
            ),
          ],
        ),
      );
    });
  }
}
