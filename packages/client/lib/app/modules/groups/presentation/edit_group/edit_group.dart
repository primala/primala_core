import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/groups.dart';
export 'edit_group_coordinator.dart';

class EditGroupScreen extends HookWidget {
  final EditGroupCoordinator coordinator;
  final GroupEntity group;
  const EditGroupScreen({
    super.key,
    required this.coordinator,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor(group);
      return null;
    }, []);
    final screenHeight = useFullScreenSize().height;
    return Observer(builder: (context) {
      return AnimatedScaffold(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HeaderRow(
              includeDivider: false,
              children: [
                LeftChevron(
                  onTap: () => coordinator.onGoBack,
                ),
                const SmartHeader(
                  content: "Edit Group",
                ),
                const LeftChevron(
                  color: NokhteColors.eggshell,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: screenHeight * .04,
                top: screenHeight * .04,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GroupAvatar(
                      groupName: coordinator.group.name,
                      profileGradient: coordinator.group.profileGradient,
                      // onPencilTap: () {},
                    ),
                  ),
                  GroupNameTextField(
                    store: coordinator.groupNameTextField,
                  ),
                ],
              ),
            ),
            GroupEditMenu(
              onInviteTapped: coordinator.goToInvite,
              onManageCollaboratorsTapped: coordinator.goToGroupMembers,
              onDeleteGroupTapped: coordinator.deleteGroup,
            )
          ],
        ),
      );
    });
  }
}
