import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/fonts/jost/jost.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/documents.dart';
import 'package:nokhte_backend/types/types.dart';

class SessionPreview extends HookWidget {
  final List<DocumentEntity> selectedDocs;
  final List<UserEntity> selectedCollaborators;
  final Function(UserEntity) onCollaboratorRemove;
  final Function(DocumentEntity) onDocRemove;

  const SessionPreview({
    super.key,
    required this.selectedDocs,
    required this.selectedCollaborators,
    required this.onCollaboratorRemove,
    required this.onDocRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 225,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            if (selectedCollaborators.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: CollaboratorsCarousel(
                  collaborators: selectedCollaborators,
                  height: 65,
                  viewportFraction: 0.15,
                  avatarSize: 45,
                  fontSize: 15,
                  showFullName: false,
                  onDeselected: onCollaboratorRemove,
                ),
              ),
            ],
            if (selectedCollaborators.isEmpty)
              Container(
                height: 75,
                alignment: Alignment.center,
                child: const Jost(
                  'No Collaborators Selected',
                  fontSize: 20,
                ),
              ),
            if (selectedDocs.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DocsCarousel(
                  docs: selectedDocs,
                  onDeselected: onDocRemove,
                ),
              ),
            ],
            if (selectedDocs.isEmpty)
              Container(
                height: 128,
                alignment: Alignment.center,
                child: const Jost(
                  'No Documents Selected',
                  fontSize: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
