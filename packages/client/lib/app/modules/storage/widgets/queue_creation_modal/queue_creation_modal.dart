import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
export 'queue_creation_modal_store.dart';

class QueueCreationModal extends HookWidget {
  final GroupDisplayModalStore store;

  const QueueCreationModal({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Jost("Create a Queue"),
        ],
      );
    });
  }
}
