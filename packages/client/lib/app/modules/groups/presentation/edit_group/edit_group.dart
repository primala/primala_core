import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/tables/groups.dart';
export 'edit_group_coordinator.dart';

class EditGroupScreen extends HookWidget {
  final EditGroupCoordinator coordinator;
  final GroupEntity group;
  final Function onGroupLeft;
  const EditGroupScreen({
    super.key,
    required this.coordinator,
    required this.group,
    required this.onGroupLeft,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor(group, onGroupLeft);
      return () => coordinator.dispose();
    }, []);
    final screenHeight = useFullScreenSize().height;
    return Observer(
      builder: (context) => AnimatedScaffold(
        showWidgets: coordinator.showWidgets,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeaderRow(
            title: "Edit Group",
            onChevronTapped: () => coordinator.onGoBack(),
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
                    onPencilTap: group.isAdmin
                        ? () {
                            Modular.to.push(
                              MaterialPageRoute(
                                builder: (context) => GroupGradientPickerScreen(
                                  onGradientTapped:
                                      coordinator.onGradientTapped,
                                  group: group,
                                ),
                              ),
                            );
                          }
                        : null,
                  ),
                ),
                GroupNameTextField(
                  store: coordinator.groupNameTextField,
                ),
              ],
            ),
          ),
          GroupEditMenu(
            isAdmin: coordinator.isAdmin,
            isNotTheOnlyAdmin: coordinator.isNotTheOnlyAdmin,
            onLeaveGroupTapped: coordinator.leaveGroup,
            groupName: coordinator.group.name,
            onInviteTapped: coordinator.goToInvite,
            onManageCollaboratorsTapped: coordinator.goToGroupMembers,
            onDeleteGroupTapped: coordinator.deleteGroup,
          )
        ],
      ),
    );
  }
}
