import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class GroupEditMenu extends HookWidget with DialogueUtils {
  final Function onInviteTapped;
  final Function onManageCollaboratorsTapped;
  final Function onDeleteGroupTapped;

  const GroupEditMenu({
    super.key,
    required this.onInviteTapped,
    required this.onManageCollaboratorsTapped,
    required this.onDeleteGroupTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GenericMenuItem(
          onTap: onInviteTapped,
          title: 'Invite',
          subtitle: 'Invite someone new to join the group',
          borderColor: Colors.black,
          showChevron: true,
        ),
        const SizedBox(height: 25),
        GenericMenuItem(
          onTap: onManageCollaboratorsTapped,
          title: 'Manage Collaborators',
          subtitle: 'Add, edit, or remove collaborators',
          borderColor: Colors.black,
          showChevron: true,
        ),
        const SizedBox(height: 25),
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
      ],
    );
  }
}
