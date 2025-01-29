import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/groups/groups.dart';

class GroupsModule extends Module {
  @override
  List<Module> get imports => [
        GroupsLogicModule(),
        GroupsWidgetsModule(),
      ];
  @override
  binds(i) {
    i.add<AccountIconPickerCoordinator>(
      () => AccountIconPickerCoordinator(
        widgets: Modular.get<AccountIconPickerWidgetsCoordinator>(),
      ),
    );

    i.add<AccountSettingsCoordinator>(
      () => AccountSettingsCoordinator(
        contract: Modular.get<UserContractImpl>(),
        animatedScaffold: AnimatedScaffoldStore(),
      ),
    );

    i.add<CreateGroupCoordinator>(
      () => CreateGroupCoordinator(
        contract: Modular.get<GroupsContractImpl>(),
        widgets: Modular.get<CreateGroupWidgetsCoordinator>(),
      ),
    );

    i.add<EditGroupCoordinator>(
      () => EditGroupCoordinator(
        contract: Modular.get<GroupsContractImpl>(),
        widgets: Modular.get<EditGroupWidgetsCoordinator>(),
      ),
    );

    i.add<GroupIconPickerCoordinator>(
      () => GroupIconPickerCoordinator(
        widgets: Modular.get<GroupIconPickerWidgetsCoordinator>(),
      ),
    );

    i.add<GroupMembersCoordinator>(
      () => GroupMembersCoordinator(
        contract: Modular.get<GroupRolesContractImpl>(),
        widgets: Modular.get<GroupMembersWidgetsCoordinator>(),
      ),
    );

    i.add<GroupPickerCoordinator>(
      () => GroupPickerCoordinator(
        widgets: Modular.get<GroupPickerWidgetsCoordinator>(),
        groupsContract: Modular.get<GroupsContractImpl>(),
        userContract: Modular.get<UserContractImpl>(),
      ),
    );

    i.add<InboxCoordinator>(
      () => InboxCoordinator(
        widgets: Modular.get<InboxWidgetsCoordinator>(),
      ),
    );

    i.add<InviteToGroupCoordinator>(
      () => InviteToGroupCoordinator(
        contract: Modular.get<GroupRolesContractImpl>(),
        widgets: Modular.get<InviteToGroupWidgetsCoordinator>(),
      ),
    );

    i.add<SelectRoleCoordinator>(
      () => SelectRoleCoordinator(
        widgets: Modular.get<SelectRoleWidgetsCoordinator>(),
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
      GroupsConstants.accountSettings,
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
