import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

mixin PresetTags {
  Widget getTag(double containerSize, Widget child, int i) => Padding(
        padding: EdgeInsets.only(right: containerSize * .04),
        child: child,
      );

  Widget getTextWidget(String text, double containerSize) => Padding(
      padding: EdgeInsets.only(left: containerSize * .02),
      child: Jost(text, fontSize: containerSize * .07));

  Widget getPaddedTag(Widget tagWidget, bool addText, SessionTags tagCode,
          double containerSize) =>
      tagWidget;

  List<Widget> fromTagsToWidgets(
    List<SessionTags> tags, {
    required double containerSize,
    bool shouldAnimate = false,
    bool isHorizontal = true,
    bool addText = false,
    double bottomPadding = 0,
  }) {
    final List<Widget> temp = [];
    for (int i = 0; i < tags.length; i++) {
      final tag = tags[i];
      if (tag == SessionTags.holdToSpeak) {
        if (i == 0 && isHorizontal) {
          temp.add(
            Container(
              width: containerSize * .02,
            ),
          );
        }
        temp.add(getPaddedTag(
          getTag(
              containerSize,
              TalkingIcons(
                shouldAnimate: shouldAnimate,
                containerSize: containerSize,
                isHoldToTalk: true,
              ),
              i),
          addText,
          tag,
          containerSize,
        ));
      } else if (tag == SessionTags.tapToSpeak) {
        temp.add(getPaddedTag(
          getTag(
              containerSize,
              TalkingIcons(
                shouldAnimate: shouldAnimate,
                containerSize: containerSize,
                isHoldToTalk: false,
              ),
              i),
          addText,
          tag,
          containerSize,
        ));
      } else if (tag == SessionTags.monoFocalNotes ||
          tag == SessionTags.multiFocalNotes) {
        temp.add(getPaddedTag(
          getTag(
              containerSize,
              NotesIcon(
                shouldAnimate: shouldAnimate,
                containerSize: containerSize,
              ),
              i),
          addText,
          tag,
          containerSize,
        ));
      } else if (tag == SessionTags.flexibleSeating) {
        temp.add(
          getPaddedTag(
            getTag(
                containerSize,
                FlexibleSeatingIcon(
                  shouldAnimate: shouldAnimate,
                  containerSize: containerSize,
                ),
                i),
            addText,
            tag,
            containerSize,
          ),
        );
      } else if (tag == SessionTags.strictSeating) {
        temp.add(
          getPaddedTag(
            getTag(
              containerSize,
              StrictSeatingIcon(
                shouldAnimate: shouldAnimate,
                containerSize: containerSize,
              ),
              i,
            ),
            addText,
            tag,
            containerSize,
          ),
        );
      }
      if (bottomPadding != 0) {
        temp.add(
          Container(
            height: bottomPadding,
          ),
        );
      }
    }
    return temp;
  }
}
