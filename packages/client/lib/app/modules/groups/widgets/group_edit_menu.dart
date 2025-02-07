import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'dart:io';

class GroupEditMenu extends HookWidget {
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
            _showDeleteGroupConfirmationDialog(context);
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

  Future<void> _showDeleteGroupConfirmationDialog(BuildContext context) async {
    final bool? confirmed = await (Platform.isIOS
        ? _showCupertinoDeleteDialog(context)
        : _showMaterialDeleteDialog(context));

    if (confirmed == true) {
      await onDeleteGroupTapped();
    }
  }

  Future<bool?> _showCupertinoDeleteDialog(BuildContext context) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          'Delete Group',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
          ),
        ),
        content: const Text('Are you sure you want to delete the group?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: NokhteColors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showMaterialDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Group'),
        content: const Text('Are you sure you want to delete the group?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
