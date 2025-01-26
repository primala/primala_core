import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
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
    final fullScreen = useFullScreenSize();
    final width = fullScreen.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMenuItem(
          width: width,
          onTap: onInviteTapped,
          text: 'Invite',
          subtext: 'Invite someone new to join the group',
          showChevron: true,
        ),
        const SizedBox(height: 25),
        _buildMenuItem(
          width: width,
          onTap: onManageCollaboratorsTapped,
          text: 'Manage Collaborators',
          subtext: 'Add, edit, or remove collaborators',
          showChevron: true,
        ),
        const SizedBox(height: 25),
        _buildMenuItem(
          width: width,
          onTap: () {
            _showDeleteGroupConfirmationDialog(context);
          },
          text: 'Delete Group',
          subtext: 'Delete this group permanently',
          textColor: Colors.red,
          showChevron: false,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required double width,
    required Function onTap,
    required String text,
    required String subtext,
    Color? textColor,
    bool showChevron = false,
  }) {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
          bottom: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            bottom: 4.0,
            top: 4.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Jost(
                    text,
                    fontSize: 16.0,
                    fontColor: textColor ?? Colors.black87,
                  ),
                  Jost(
                    subtext,
                    fontSize: 12,
                    fontColor: Colors.black.withOpacity(.6),
                  ),
                ],
              ),
              if (showChevron)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    CupertinoIcons.chevron_right,
                    size: 20,
                    // weight: 100,
                    color: Colors.black,
                  ),
                )
            ],
          ),
        ),
      ),
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
