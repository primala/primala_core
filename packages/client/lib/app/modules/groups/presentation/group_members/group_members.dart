import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'group_members_coordinator.dart';
export 'group_members_widgets_coordinator.dart';

class GroupMembersScreen extends HookWidget {
  final GroupMembersCoordinator coordinator;
  final GroupEntity group;
  const GroupMembersScreen({
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HeaderRow(
                children: [
                  LeftChevron(
                    onTap: coordinator.onGoBack,
                  ),
                  const SmartHeader(
                    content: "Group Members",
                  ),
                  const Expanded(
                    child: LeftChevron(
                      color: NokhteColors.eggshell,
                    ),
                  ),
                ],
              ),
              GroupMembersList(
                coordinator.groupMembers,
                onMemberTapped: coordinator.onMemberTapped,
              ),
            ],
          ),
        ),
      );
    });
  }
}
