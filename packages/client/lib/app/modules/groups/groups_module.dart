import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';

class GroupsModule extends Module {
  @override
  List<Module> get imports => [
        GroupsLogicModule(),
        PosthogModule(),
        ActiveGroupModule(),
      ];
  @override
  binds(i) {
    i.add<AccountSettingsCoordinator>(
      () => AccountSettingsCoordinator(
        captureScreen: Modular.get<CaptureScreen>(),
        contract: Modular.get<UserContractImpl>(),
        animatedScaffold: AnimatedScaffoldStore(),
      ),
    );

    i.add<CreateGroupCoordinator>(
      () => CreateGroupCoordinator(
        contract: Modular.get<GroupsContractImpl>(),
        captureScreen: Modular.get<CaptureScreen>(),
        groupNameTextField: GroupNameTextFieldStore(),
      ),
    );

    i.add<EditGroupCoordinator>(
      () => EditGroupCoordinator(
        captureScreen: Modular.get<CaptureScreen>(),
        contract: Modular.get<GroupsContractImpl>(),
        groupNameTextField: GroupNameTextFieldStore(),
      ),
    );

    i.add<GroupMembersCoordinator>(
      () => GroupMembersCoordinator(
        contract: Modular.get<GroupRolesContractImpl>(),
        captureScreen: Modular.get<CaptureScreen>(),
      ),
    );

    i.add<GroupPickerCoordinator>(
      () => GroupPickerCoordinator(
        groupsContract: Modular.get<GroupsContractImpl>(),
        captureScreen: Modular.get<CaptureScreen>(),
        userContract: Modular.get<UserContractImpl>(),
        activeGroup: Modular.get<ActiveGroup>(),
        groupDisplay: GroupDisplayStore(),
      ),
    );

    i.add<InviteToGroupCoordinator>(
      () => InviteToGroupCoordinator(
        contract: Modular.get<GroupRolesContractImpl>(),
        captureScreen: Modular.get<CaptureScreen>(),
        invitationBody: InvitationBodyStore(),
      ),
    );
  }

  @override
  routes(r) {
    r.child(
      GroupsConstants.relativeCreateGroup,
      transition: TransitionType.noTransition,
      child: (context) => CreateGroupScreen(
        coordinator: Modular.get<CreateGroupCoordinator>(),
      ),
    );

    r.child(
      GroupsConstants.relativeUpdateApp,
      transition: TransitionType.noTransition,
      child: (context) => const UpdateAppScreen(),
    );

    r.child(
      GroupsConstants.relativeAccountSettings,
      transition: TransitionType.noTransition,
      child: (context) => AccountSettingsScreen(
        coordinator: Modular.get<AccountSettingsCoordinator>(),
      ),
    );

    r.child(
      GroupsConstants.relativeGroupPicker,
      transition: TransitionType.noTransition,
      child: (context) => GroupPickerScreen(
        coordinator: Modular.get<GroupPickerCoordinator>(),
      ),
    );
  }
}
