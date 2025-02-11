export 'block_text_display_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'context_menu/context_menu.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class BlockTextDisplay extends HookWidget {
  final BlockTextDisplayStore store;
  final Color fontColor;
  const BlockTextDisplay({
    super.key,
    required this.store,
    this.fontColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final width = useFullScreenSize().width;
    useEffect(() {
      store.constructor();

      return () => store.dispose();
    }, []);
    return Observer(builder: (context) {
      final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
      return SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...store.content.map((element) {
              final index = store.content.indexOf(element);
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
                      store.setSwipeProgress(progress.value, index);
                      return Row(
                        children: [
                          SizedBox(width: (progress.value * 50)), //
                          Icon(
                            Icons.reply,
                            color: fontColor,
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
                  HapticFeedback.mediumImpact();

                  store.onParentSelected(element.id);
                  return false;
                },
                child: Observer(builder: (context) {
                  return AnimatedPadding(
                    padding: EdgeInsets.only(
                        left: store.swipeProgresses[index] * 100),
                    // padding: EdgeInsets.all(padValue),
                    duration: Duration.zero,
                    curve: Curves.easeInOut,
                    child: GestureDetector(
                      onLongPressStart: (details) {
                        HapticFeedback.mediumImpact();
                        showContextMenu(
                          context,
                          contextMenu: ContextMenu(
                            boxDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.white,
                            ),
                            entries: <ContextMenuEntry>[
                              // const MenuHeader(text: "Context Menu"),
                              MenuItem(
                                label: 'edit',
                                iconPath: 'pencil_icon',
                                onSelected: () {
                                  store.onEdit(element);
                                },
                              ),
                              MenuItem(
                                label: 'delete',
                                iconPath: 'trash_icon_black',
                                onSelected: () {
                                  store.setItemIdToDelete(element.id);
                                },
                              ),
                            ],
                            position: details.globalPosition,
                            padding: const EdgeInsets.all(8.0),
                          ),
                        );
                      },
                      child: Container(
                        // width: width,
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
                            gradient: BlockTextConstants.getGradient(
                              element.type,
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
                                BlockTextConstants.getAssetPath(element.type),
                                width: 25,
                                height: 25,
                              ),
                            ),
                            Jost(
                              '${BlockTextConstants.whiteSpace}${element.content}',
                              fontSize: 16,
                              softWrap: true,
                              fontColor: fontColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
            SizedBox(
              height: bottomPadding + store.blockTextFields.textFieldHeight,
            ),
          ],
        ),
      );
    });
  }
}
