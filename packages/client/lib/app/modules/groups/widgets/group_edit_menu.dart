import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class GroupEditMenu extends HookWidget with DialogueUtils {
  final Function onInviteTapped;
  final Function onManageCollaboratorsTapped;
  final Function onLeaveGroupTapped;
  final Function onDeleteGroupTapped;
  final bool isAdmin;
  final bool isNotTheOnlyAdmin;
  final String groupName;

  const GroupEditMenu({
    super.key,
    required this.onInviteTapped,
    required this.isAdmin,
    required this.isNotTheOnlyAdmin,
    required this.onManageCollaboratorsTapped,
    required this.onDeleteGroupTapped,
    required this.onLeaveGroupTapped,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAdmin)
          GenericMenuItem(
            onTap: onInviteTapped,
            title: 'Invite',
            subtitle: 'Invite someone new to join the group',
            borderColor: Colors.black,
            showChevron: true,
          ),
        if (isAdmin) const SizedBox(height: 25),
        if (isAdmin)
          GenericMenuItem(
            onTap: onManageCollaboratorsTapped,
            title: 'Manage Collaborators',
            subtitle: 'Add, edit, or remove collaborators',
            borderColor: Colors.black,
            showChevron: true,
          ),
        if (isAdmin) const SizedBox(height: 25),
        if (isAdmin)
          GenericMenuItem(
            onTap: () {
              showDeleteConfirmationDialog(
                context: context,
                title: 'Delete Group',
                content: 'Are you sure you want to delete the group?',
                onConfirm: () async => await onDeleteGroupTapped(),
              );
            },
            title: 'Delete Group',
            subtitle: 'Delete this group permanently',
            borderColor: Colors.black,
            textColor: Colors.red,
            showChevron: false,
          ),
        if (isAdmin) const SizedBox(height: 25),
        if ((isAdmin && isNotTheOnlyAdmin) || !isAdmin)
          GenericMenuItem(
            onTap: () {
              showDeleteConfirmationDialog(
                context: context,
                title: 'Leave Group',
                content: 'Are you sure you want to leave $groupName?',
                onConfirm: () async => await onLeaveGroupTapped(),
              );
            },
            title: 'Leave Group',
            subtitle: 'Leave this group',
            borderColor: Colors.black,
            textColor: Colors.red,
            showChevron: false,
          ),
      ],
    );
  }
}
