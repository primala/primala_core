// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/base_widget_store.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte/app/modules/session/session.dart';

part 'purpose_banner_store.g.dart';

class PurposeBannerStore = _PurposeBannerStoreBase with _$PurposeBannerStore;

abstract class _PurposeBannerStoreBase extends BaseWidgetStore<NoParams>
    with Store {
  final NokhteBlurStore blur = NokhteBlurStore();
  final ViewDocCoordinator viewDocCoordinator;
  final BlockTextDisplayStore blockTextDisplay;
  final BlockTextFieldsStore blockTextFields;

  _PurposeBannerStoreBase({
    required this.viewDocCoordinator,
  })  : blockTextFields = viewDocCoordinator.blockTextDisplay.blockTextFields,
        blockTextDisplay = viewDocCoordinator.blockTextDisplay;

  late BuildContext buildContext;
  // late AnimationController controller;

  @action
  constructor(BuildContext buildContext) {
    setWidgetVisibility(false);
    this.buildContext = buildContext;
    Timer(Seconds.get(0, milli: 1), () {
      setWidgetVisibility(true);
    });
  }

  @observable
  String currentFocus = 'No Focus Yet';

  @observable
  bool modalIsVisible = false;

  @action
  setModalIsVisible(bool value) => modalIsVisible = value;

  @action
  setFocus(String content) {
    currentFocus = content;
  }

  @action
  onTap() => tapCount++;

  @action
  showModal({
    required Function onOpen,
    required Function onClose,
  }) {
    if (!modalIsVisible) {
      onOpen();
      setModalIsVisible(true);
      blur.init(
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
        backgroundColor: const Color(0xFFA7A59F),
        context: buildContext,
        builder: (context) => DraggableScrollableSheet(
          maxChildSize: .91,
          initialChildSize: .9,
          minChildSize: .7,
          expand: false,
          builder: (context, scrollController) => MultiHitStack(
            children: [
              NokhteBlur(
                store: blur,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  controller: blockTextDisplay.scrollController,
                  child: Observer(builder: (context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DocHeader(
                          color: Colors.white,
                          onChanged: viewDocCoordinator.onTitleChanged,
                          controller: viewDocCoordinator.docTitleController,
                          text: viewDocCoordinator.title,
                        ),
                        SpotlightStatement(
                          onTextUpdated:
                              viewDocCoordinator.onSpotlightTextChanged,
                          controller: viewDocCoordinator.spotlightController,
                          externalBlockType:
                              viewDocCoordinator.spotlightContentBlock.type,
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          alignment: Alignment.centerRight,
                          child: Jost(
                            '${viewDocCoordinator.characterCount}/2000',
                            fontSize: 14,
                            fontColor: Colors.white,
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 1,
                          height: 20,
                        ),
                        const SizedBox(height: 20),
                        BlockTextDisplay(
                          store: blockTextDisplay,
                          fontColor: Colors.white,
                        ),
                      ],
                    );
                  }),
                ),
              ),
              BlockTextFields(
                store: blockTextDisplay.blockTextFields,
                fontColor: Colors.white,
                baseColor: const Color(0xFFA7A59F),
              ),
            ],
          ),
        ),
      ).whenComplete(() {
        onClose();
        blur.reverse();
        setWidgetVisibility(true);
      });
    }
  }
}
