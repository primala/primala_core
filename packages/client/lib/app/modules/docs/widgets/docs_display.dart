import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DocsDisplay extends HookWidget {
  final Function onDocTapped;
  final Function onCreateDocTapped;
  // final List<DocumentEntity> docs;
  final List docs;

  const DocsDisplay({
    super.key,
    required this.onDocTapped,
    required this.onCreateDocTapped,
    required this.docs,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
