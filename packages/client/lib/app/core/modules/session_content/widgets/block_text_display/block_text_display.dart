export 'block_text_display_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:nokhte/app/core/modules/session_content/session_content.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/widgets/purpose_banner/widgets/purpose_with_conclusions/swipable_tiles/swipable_tiles.dart';

class BlockTextDisplay extends HookWidget {
  final BlockTextDisplayStore store;
  const BlockTextDisplay({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
      return FullScreen(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...store.content.map((element) {
              return SwipeableTile(
                isElevated: false,
                swipeThreshold: .2,
                swipeWidth: 400,
                direction: SwipeDirection.startToEnd,
                key: UniqueKey(),
                backgroundBuilder: (context, direction, progress) {
                  return AnimatedBuilder(
                    animation: progress,
                    builder: (context, child) {
                      store.setSwipeProgress(progress.value);
                      return Row(
                        children: [
                          SizedBox(width: (progress.value * 50)), //
                          Icon(
                            Icons.reply,
                            color: Colors.white,
                            size: progress.value * 250,
                          ),
                          SizedBox(
                              width: (progress.value *
                                  100)), // Slides icon in from left
                        ],
                      );
                    },
                  );
                },
                color: Colors.transparent,
                onSwiped: (direction) {},
                confirmSwipe: (_) async {
                  store.onParentSelected(element.uid);
                  return false;
                },
                child: Observer(builder: (context) {
                  return AnimatedPadding(
                    padding: EdgeInsets.only(left: store.swipeProgress * 100),
                    // padding: EdgeInsets.all(padValue),
                    duration: Duration.zero,
                    curve: Curves.easeInOut,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 16.0 *
                            (element.numberOfParents == 0
                                ? 1
                                : element.numberOfParents + 1),
                        right: 16.0,
                        bottom: 10,
                      ),
                      padding: const EdgeInsets.all(
                        12.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: GradientBoxBorder(
                          gradient: LinearGradient(
                            colors: BlockTextConstants.getGradient(
                                    element.blockType)
                                .map((e) => e.color)
                                .toList(),
                            stops: const [0, 1],
                          ),
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -2,
                            left: 0,
                            child: Image.asset(
                              BlockTextConstants.getAssetPath(
                                  element.blockType),
                              width: 25,
                              height: 25,
                            ),
                          ),
                          Jost(
                            '${BlockTextConstants.whiteSpace}${element.content}',
                            fontSize: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            }),
            SizedBox(
              height: bottomPadding + 80,
            ),
          ],
        ),
      );
    });
  }
}
