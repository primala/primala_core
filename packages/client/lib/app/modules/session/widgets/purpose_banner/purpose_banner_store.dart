// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/base_widget_store.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/modules/session_content/session_content.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

part 'purpose_banner_store.g.dart';

class PurposeBannerStore = _PurposeBannerStoreBase with _$PurposeBannerStore;

abstract class _PurposeBannerStoreBase extends BaseWidgetStore<NoParams>
    with Store {
  final NokhteBlurStore blur;
  final BlockTextDisplayStore blockTextDisplay;
  final BlockTextFieldsStore blockTextFields;

  _PurposeBannerStoreBase({
    required this.blur,
    required this.blockTextDisplay,
  }) : blockTextFields = blockTextDisplay.blockTextFields;

  late BuildContext buildContext;
  // late AnimationController controller;

  @action
  constructor(BuildContext buildContext) {
    this.buildContext = buildContext;
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
        backgroundColor: Colors.black.withOpacity(.2),
        context: buildContext,
        builder: (context) => DraggableScrollableSheet(
          maxChildSize: .91,
          initialChildSize: .9,
          minChildSize: .7,
          expand: false,
          builder: (context, scrollController) => Observer(
            builder: (context) => MultiHitStack(
              children: [
                NokhteBlur(
                  store: blur,
                ),
                SingleChildScrollView(
                  controller: scrollController,
                  child: Observer(
                    builder: (context) => SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BlockTextDisplay(
                              store: blockTextDisplay,
                            ),
                          ],
                        ),
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
        ),
      ).whenComplete(() {
        onClose();
        blur.reverse();
        setModalIsVisible(false);
      });
    }
  }
}
