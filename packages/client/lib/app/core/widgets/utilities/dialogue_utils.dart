import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'dart:io';

mixin DialogueUtils {
  Future<void> showDeleteConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function onConfirm,
    String? cancelText,
    String? confirmText,
  }) async {
    final bool? confirmed = await (Platform.isIOS
        ? _showCupertinoDeleteDialog(
            context: context,
            title: title,
            content: content,
            cancelText: cancelText,
            confirmText: confirmText,
          )
        : _showMaterialDeleteDialog(
            context: context,
            title: title,
            content: content,
            cancelText: cancelText,
            confirmText: confirmText,
          ));

    if (confirmed == true) {
      await onConfirm();
    }
  }

  Future<bool?> _showCupertinoDeleteDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? cancelText,
    String? confirmText,
  }) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelText ?? 'Cancel',
              style: GoogleFonts.inter(
                color: NokhteColors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText ?? 'Confirm'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showMaterialDeleteDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? cancelText,
    String? confirmText,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelText ?? 'Cancel',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(confirmText ?? 'Confirm'),
          ),
        ],
      ),
    );
  }
}
