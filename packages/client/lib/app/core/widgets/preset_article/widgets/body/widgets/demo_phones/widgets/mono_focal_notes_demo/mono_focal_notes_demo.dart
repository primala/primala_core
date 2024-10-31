import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
import 'package:simple_animations/simple_animations.dart';
import 'mono_focal_notes_demo_painter.dart';

class MonoFocalNotesDemo extends HookWidget {
  final List<SessionTags> allTheTags;
  const MonoFocalNotesDemo(
    this.allTheTags, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = useFullScreenSize().width;
    return CustomAnimationBuilder(
        tween: NotesDemoMovies.monoFocal,
        duration: NotesDemoMovies.monoFocal.duration,
        control: Control.loop,
        builder: (context, value, child) {
          return SizedBox(
            height: width,
            width: width,
            child: CustomPaint(
              painter: MonoFocalNotesDemoPainter(
                slightlyAboveCenterTextOpacity: value.get('p1Text'),
                slightlyBelowCenterTextOpacity: value.get('p1Text'),
                aboveCenterTextOpacity: value.get('p2AboveTextOpacity'),
                aboveCenterTextProgress: value.get('p2AboveTextProgress'),
                belowCenterTextOpacity: value.get('p2BelowText'),
                containerSize: width,
                allTheTags: allTheTags,
                leftPhoneColorsList:
                    GetCurrentWaterAnimation.colors(value, prefix: 'l'),
                leftPhoneStopsList:
                    GetCurrentWaterAnimation.stops(value, prefix: 'l'),
                rightPhoneColorsList:
                    GetCurrentWaterAnimation.colors(value, prefix: 'r'),
                rightPhoneStopsList:
                    GetCurrentWaterAnimation.stops(value, prefix: 'r'),
              ),
            ),
          );
        });
  }
}
