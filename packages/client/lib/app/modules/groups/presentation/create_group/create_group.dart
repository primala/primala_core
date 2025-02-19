import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
export 'create_group_coordinator.dart';

class CreateGroupScreen extends HookWidget {
  final CreateGroupCoordinator coordinator;
  const CreateGroupScreen({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
    }, []);

    final screenHeight = useFullScreenSize().height;

    return Observer(builder: (context) {
      return AnimatedScaffold(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              HeaderRow(
                title: 'Create Group',
                onChevronTapped: coordinator.onGoBack,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * .13),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GroupAvatar(
                    groupName: coordinator.groupNameTextField.groupName,
                    profileGradient:
                        coordinator.groupNameTextField.profileGradient,
                  ),
                ),
                GroupNameTextField(
                  store: coordinator.groupNameTextField,
                ),
              ],
            ),
          ),
          GenericButton(
            isEnabled: coordinator.groupNameTextField.isValidInput,
            label: "Create Group",
            onPressed: coordinator.createGroup,
            borderRadius: 10,
          )
        ],
      );
    });
  }
}
