import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
export 'widgets/widgets.dart';

class Options extends HookWidget {
  final List<ArticleOptions> options;
  final List<SessionTags> articleSections;
  final ToggleCallback onToggle;

  Options({
    super.key,
    required this.options,
    required this.onToggle,
    required this.articleSections,
  }) {
    // print('articleSections: $articleSections');
  }

  List<Widget> _getToggles(List<ArticleOptions> options) {
    return options
        .map((option) {
          switch (option) {
            case ArticleOptions.notesToggle:
              return ArticleToggle(
                articleSections: articleSections,
                leftToggle: SessionTags.deactivatedNotes,
                rightToggle: SessionTags.multiFocalNotes,
                label: 'Notes',
                onToggle: onToggle,
              );
            case ArticleOptions.talkingToggle:
              return ArticleToggle(
                articleSections: articleSections,
                leftToggle: SessionTags.tapToSpeak,
                rightToggle: SessionTags.holdToSpeak,
                label: 'Speaking',
                glyphs: const ['T', 'H'],
                onToggle: onToggle,
              );
            default:
              return Container();
          }
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return options.isNotEmpty
        ? Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Chivo(
                  'Options: ',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  height: 1.5, // Thin line
                  color: Colors.white.withOpacity(0.45),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _getToggles(options),
                ),
              ),
            ],
          )
        : Container();
  }
}
