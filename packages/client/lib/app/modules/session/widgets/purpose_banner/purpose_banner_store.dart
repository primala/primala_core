// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/mobx/base_widget_store.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:simple_animations/simple_animations.dart';
part 'purpose_banner_store.g.dart';

class PurposeBannerStore = _PurposeBannerStoreBase with _$PurposeBannerStore;

abstract class _PurposeBannerStoreBase extends BaseWidgetStore<NoParams>
    with Store {
  final NokhteBlurStore nokhteBlur;

  _PurposeBannerStoreBase({
    required this.nokhteBlur,
  });

  late BuildContext buildContext;
  late AnimationController controller;

  final TextEditingController textEditingController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

  @action
  constructor(context, controller) {
    if (tapCount == 0) {
      buildContext = context;
      this.controller = controller;
      tapCount++;
    }
  }

  @observable
  ObservableList<String> sessionContent = ObservableList.of(['No purpose yet']);

  @observable
  bool showModal = false;

  @observable
  bool showTextInput = false;

  @observable
  int currentPurposeIndex = -1;

  Function(AddContentParams params) addContent = (params) {};

  @action
  setAddContent(Function(AddContentParams params) value) => addContent = value;

  @action
  setCurrentPurposeIndex(int index) {
    currentPurposeIndex = index;
  }

  @action
  setShowModal(bool value) => showModal = value;

  @action
  setSessionContent(ObservableList<String> content) {
    sessionContent = content;
  }

  @observable
  String purpose = '';

  @action
  setPurpose(ObservableList<String> content) {
    nokhteBlur.setControl(Control.stop);
    if (content.isNotEmpty) {
      if ((content.last != purpose && content.last.contains("P: ")) ||
          purpose.isEmpty) {
        setWidgetVisibility(false);
      }
    } else {
      setWidgetVisibility(false);
    }
    Timer(Seconds.get(0, milli: 500), () {
      if (content.isEmpty) {
        purpose = 'No purpose yet';
      } else {
        sessionContent = content;
        // if (content.last.contains("P: ")) {
        //   purpose = content.last.substring(3);
        // } else {
        purpose = content
            .lastWhere((element) => element.contains("P: "))
            .substring(3);
        // }
      }
      setWidgetVisibility(true);
    });
  }

  @action
  toggleTextInput(bool value) {
    if (value) {
      textFieldFocusNode.requestFocus();
      showTextInput = value;
    } else {
      textFieldFocusNode.unfocus();
      showTextInput = value;
    }
  }

  int getIsertionIndex(
    List<String> list,
    int purposeIndex,
  ) {
    int insertIndex = list.length;

    for (int i = purposeIndex + 1; i < list.length; i++) {
      if (list[i].startsWith("P: ")) {
        insertIndex = i;
        break;
      }
    }

    return insertIndex;
  }

  AddContentParams getParams(
    int purposeIndex,
  ) {
    return AddContentParams(
      content: 'C: ${textEditingController.text}',
      insertAt: getIsertionIndex(sessionContent, purposeIndex),
    );
  }

  @action
  onTap(
      // Function(AddContentParams params) addContent,
      ) {
    if (showWidget && !showModal) {
      setShowModal(true);
      nokhteBlur.init(
        end: Seconds.get(0, milli: 200),
      );
      showModalBottomSheet(
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(36),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.black.withOpacity(.2),
        context: buildContext,
        builder: (context) => DraggableScrollableSheet(
          maxChildSize: .91,
          initialChildSize: .9,
          minChildSize: .7,
          expand: false,
          builder: (context, scrollController) => Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Observer(
                  builder: (context) => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: PurposeConclusionBody(
                      sessionContent: sessionContent,
                      onTap: (int index) {
                        toggleTextInput(true);
                        setCurrentPurposeIndex(index);
                      },
                    ),
                  ),
                ),
              ),
              Observer(builder: (context) {
                return Positioned(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: useWidgetOpacity(showTextInput),
                    duration: Seconds.get(1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              maxLength: 104,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              // maxLines: 1,
                              controller: textEditingController,
                              focusNode: textFieldFocusNode,
                              decoration: const InputDecoration(
                                hintText: 'Type your message...',
                                counterText: '',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (text) async {
                                toggleTextInput(false);
                                Timer(Seconds.get(1), () {
                                  textEditingController.clear();
                                });
                                if (text.isNotEmpty) {
                                  await addContent(
                                      getParams(currentPurposeIndex));
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () async {
                              toggleTextInput(false);
                              Timer(Seconds.get(1), () {
                                textEditingController.clear();
                              });
                              if (textEditingController.text.isNotEmpty) {
                                await addContent(
                                    getParams(currentPurposeIndex));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ).whenComplete(() {
        nokhteBlur.reverse();
        setShowModal(false);
      });
    }
  }
}
