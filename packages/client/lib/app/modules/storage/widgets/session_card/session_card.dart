import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
export 'session_card_store.dart';
export 'session_card.dart';

class SessionCard extends HookWidget {
  final SessionCardStore store;
  final List<SessionArtifactEntity> sessions;
  const SessionCard({
    super.key,
    required this.sessions,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final height = useFullScreenSize().height;
    final screenSize = useFullScreenSize();
    useEffect(() {
      if (sessions.isNotEmpty) {
        store.setWidgetVisibility(true);
      }
      return null;
    }, [sessions]);
    return Observer(builder: (context) {
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(1),
        child: sessions.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 80.0),
                  child: Jost(
                    "No Sessions Found",
                    fontSize: 25,
                  ),
                ),
              )
            : ListView.separated(
                physics: store.disableTouchInput
                    ? const NeverScrollableScrollPhysics()
                    : null,
                itemCount: sessions.length,
                addAutomaticKeepAlives: true,
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.all(height * .02),
                  child: Container(),
                ),
                itemBuilder: (context, index) {
                  if (!store.hasBeenInitiallySet[index]) {
                    final newController = TextEditingController();
                    store.textEditingControllers.add(newController);
                    newController.text = sessions[index].title;
                  }

                  return Observer(builder: (context) {
                    return MultiHitStack(
                      children: [
                        AnimatedOpacity(
                          opacity: useWidgetOpacity(store.showListBox),
                          duration: Seconds.get(1),
                          child: GestureDetector(
                            onTap: () => store.onTap(index),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: height * .04),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        width: 2, color: Colors.white)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 60,
                                            ),
                                            child: Theme(
                                              data: ThemeData(
                                                textSelectionTheme:
                                                    const TextSelectionThemeData(
                                                  selectionColor:
                                                      Color.fromARGB(
                                                          255, 7, 190, 172),
                                                ),
                                              ),
                                              child: TextFormField(
                                                controller: store
                                                        .textEditingControllers[
                                                    index],
                                                readOnly: true,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.jost(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                                cursorColor: Colors.white,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => store.onDoubleTap(index),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: NotesIcon(
                                              containerSize: useScaledSize(
                                                  baseValue: .18,
                                                  screenSize: screenSize),
                                              shouldAnimate: false,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Jost(
                                        " ${sessions[index].date}",
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        index == 0
                            ? AnimatedOpacity(
                                opacity: useWidgetOpacity(store.showTextBox),
                                duration: Seconds.get(1),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: height * .04),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            width: 2, color: Colors.white)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 60.0,
                                                ),
                                                child: Theme(
                                                  data: ThemeData(
                                                    textSelectionTheme:
                                                        const TextSelectionThemeData(
                                                      selectionColor:
                                                          Color.fromARGB(
                                                              255, 7, 190, 172),
                                                    ),
                                                  ),
                                                  child: TextFormField(
                                                    readOnly: !store
                                                            .showTextBox &&
                                                        !store
                                                            .disableTouchInput,
                                                    onTapOutside: (details) =>
                                                        store.onTapOutside(
                                                      sessions[store
                                                              .lastSelectedIndex]
                                                          .sessionUID,
                                                      store
                                                          .textEditingControllers[
                                                              store
                                                                  .lastSelectedIndex]
                                                          .text,
                                                    ),
                                                    focusNode: store.focusNode,
                                                    controller: store
                                                            .textEditingControllers[
                                                        store
                                                            .lastSelectedIndex],
                                                    onFieldSubmitted: (value) {
                                                      store.onEdit(
                                                        sessions[store
                                                                .lastSelectedIndex]
                                                            .sessionUID,
                                                        value,
                                                      );
                                                    },
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.jost(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ),
                                                    cursorColor: Colors.white,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText:
                                                          "A memorable title",
                                                      hintStyle: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.white
                                                            .withOpacity(.4),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Jost(
                                            " ${sessions[index].date}",
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    );
                  });
                },
              ),
      );
    });
  }
}
