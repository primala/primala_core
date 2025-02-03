import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte_backend/tables/documents.dart';

class DocsDisplay extends HookWidget {
  final Function(int) onDocTapped;
  final Function() onCreateDocTapped;
  final DocumentEntities docs;

  const DocsDisplay({
    super.key,
    required this.onDocTapped,
    required this.onCreateDocTapped,
    required this.docs,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = useFullScreenSize().height * .7;
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
            itemCount: docs.length + 1,
            itemBuilder: (context, index) {
              if (index == docs.length) {
                if (true) {
                  return GestureDetector(
                    onTap: () => onCreateDocTapped(),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                          child: Image.asset(
                        'assets/groups/plus_icon.png',
                        width: 80,
                        height: 80,
                      )),
                    ),
                  );
                }
              }

              final doc = docs[index];
              return _buildDocItem(index, doc);
            }),
      ),
    );
  }

  Widget _buildDocItem(int index, DocumentEntity doc) => GestureDetector(
        onTap: () => onDocTapped(index),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(child: Text(doc.title)),
        ),
      );
}
