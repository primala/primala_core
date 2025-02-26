import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/documents.dart';
export 'doc_item.dart';

class DocsDisplay extends HookWidget {
  final Function(int) onDocTapped;
  final DocumentEntities docs;

  const DocsDisplay({
    super.key,
    required this.onDocTapped,
    required this.docs,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = useFullScreenSize().height * 0.7;
    return SizedBox(
      height: bottomPadding,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 32,
          right: 32,
        ),
        child: GridView.builder(
          shrinkWrap: true,
          // height: bbottomPadding,
          // physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: bottomPadding,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 22,
            mainAxisSpacing: 22,
            childAspectRatio: .76,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) => DocItem(
            size: const Size(98, 130),
            doc: docs[index],
            onTap: () => onDocTapped(index),
          ),
        ),
      ),
    );
  }
}
