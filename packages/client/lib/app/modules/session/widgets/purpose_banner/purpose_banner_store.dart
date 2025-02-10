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
  final BlockTextDisplayStore blockTextDisplay;
  final BlockTextFieldsStore blockTextFields;

  _PurposeBannerStoreBase({
    required this.blockTextDisplay,
  }) : blockTextFields = blockTextDisplay.blockTextFields;

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
    required Widget spotlightStatement,
  }) {
    if (true) {
      print(' is this being called $modalIsVisible');
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
        backgroundColor: Colors.black.withOpacity(.4),
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
              Observer(
                builder: (context) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    controller: blockTextDisplay.scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        spotlightStatement,
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
                    ),
                  ),
                ),
              ),
              BlockTextFields(
                store: blockTextDisplay.blockTextFields,
              ),
            ],
          ),
        ),
      ).whenComplete(() {
        onClose();
        blur.reverse();
        setModalIsVisible(false);
      });
    }
  }
}
