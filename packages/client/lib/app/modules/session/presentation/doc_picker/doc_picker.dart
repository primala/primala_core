import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/documents/documents.dart';

class DocPicker extends HookWidget {
  final Function(int) onDocPicked;
  final List<DocumentEntity> docs;

  const DocPicker({
    super.key,
    required this.onDocPicked,
    required this.docs,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScaffold(
      children: [
        HeaderRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LeftChevron(
              onTap: () => Modular.to.pop(),
            ),
            const SmartHeader(
              content: "Documents",
            ),
            const LeftChevron(
              color: NokhteColors.eggshell,
            ),
          ],
        ),
        DocsDisplay(
          docs: docs,
          onDocTapped: (i) async {
            await onDocPicked(docs[i].id);
            Modular.to.pop();
          },
        ),
      ],
    );
  }
}
