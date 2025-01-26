import 'package:flutter_modular/flutter_modular.dart';
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
        widgets: Modular.get<AccountSettingsWidgetsCoordinator>(),
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
        contract: Modular.get<GroupsContractImpl>(),
        widgets: Modular.get<GroupMembersWidgetsCoordinator>(),
      ),
    );

    i.add<GroupPickerCoordinator>(
      () => GroupPickerCoordinator(
        widgets: Modular.get<GroupPickerWidgetsCoordinator>(),
        contract: Modular.get<GroupsContractImpl>(),
      ),
    );

    i.add<InboxCoordinator>(
      () => InboxCoordinator(
        widgets: Modular.get<InboxWidgetsCoordinator>(),
      ),
    );

    i.add<InviteToGroupCoordinator>(
      () => InviteToGroupCoordinator(
        contract: Modular.get<GroupsContractImpl>(),
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
      GroupsConstants.relativeAccountIconPicker,
      transition: TransitionType.noTransition,
      child: (context) => AccountIconPickerScreen(
        coordinator: Modular.get<AccountIconPickerCoordinator>(),
      ),
    );

    r.child(
      GroupsConstants.relativeAccountSettings,
      transition: TransitionType.noTransition,
      child: (context) => AccountSettingsScreen(
        coordinator: Modular.get<AccountSettingsCoordinator>(),
      ),
    );

    r.child(
      GroupsConstants.relativeCreateGroup,
      transition: TransitionType.noTransition,
      child: (context) => CreateGroupScreen(
        coordinator: Modular.get<CreateGroupCoordinator>(),
      ),
    );

    r.child(
      GroupsConstants.relativeEditGroup,
      transition: TransitionType.noTransition,
      child: (context) => EditGroupScreen(
        coordinator: Modular.get<EditGroupCoordinator>(),
      ),
    );

    r.child(
      GroupsConstants.relativeGroupIconPicker,
      transition: TransitionType.noTransition,
      child: (context) => GroupIconPickerScreen(
        coordinator: Modular.get<GroupIconPickerCoordinator>(),
      ),
    );

    r.child(
      GroupsConstants.relativeGroupMembers,
      transition: TransitionType.noTransition,
      child: (context) => GroupMembersScreen(
        coordinator: Modular.get<GroupMembersCoordinator>(),
      ),
    );

    r.child(
      GroupsConstants.relativeGroupPicker,
      transition: TransitionType.noTransition,
      child: (context) => GroupPickerScreen(
        coordinator: Modular.get<GroupPickerCoordinator>(),
      ),
    );

    r.child(
      GroupsConstants.relativeInbox,
      transition: TransitionType.noTransition,
      child: (context) => InboxScreen(
        coordinator: Modular.get<InboxCoordinator>(),
      ),
    );

    r.child(
      GroupsConstants.relativeInviteToGroup,
      transition: TransitionType.noTransition,
      child: (context) => InviteToGroupScreen(
        coordinator: Modular.get<InviteToGroupCoordinator>(),
      ),
    );

    r.child(
      GroupsConstants.relativeSelectRole,
      transition: TransitionType.noTransition,
      child: (context) => SelectRoleScreen(
        coordinator: Modular.get<SelectRoleCoordinator>(),
      ),
    );
  }
}
