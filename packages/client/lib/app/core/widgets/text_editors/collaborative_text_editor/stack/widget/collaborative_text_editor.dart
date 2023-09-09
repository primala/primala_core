// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state
import 'package:flutter/material.dart';
import 'package:primala/app/core/widgets/text_editors/core/core.dart';
import 'package:primala/app/core/widgets/text_editors/mobx.dart';

class CollaborativeTextEditor extends StatefulWidget {
  final CollaborativeTextEditorTrackerStore trackerStore;

  const CollaborativeTextEditor({
    super.key,
    required this.trackerStore,
  });

  @override
  State<StatefulWidget> createState() => _CollaborativeTextEditorState(
        trackerStore: trackerStore,
      );
}

class _CollaborativeTextEditorState extends State<CollaborativeTextEditor> {
  final CollaborativeTextEditorTrackerStore trackerStore;
  _CollaborativeTextEditorState({required this.trackerStore});
  @override
  void dispose() {
    super.dispose();
    trackerStore.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BaseTextEditor(
          trackerStore: trackerStore.collaboratorStore,
        ),
        BaseTextEditor(
          trackerStore: trackerStore.userStore,
        ),
      ],
    );
  }
}
