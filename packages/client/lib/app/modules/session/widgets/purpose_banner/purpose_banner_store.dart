// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/base_widget_store.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
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

  @action
  setShowModal(bool value) => showModal = value;

  @action
  setSessionContent(ObservableList<String> content) {
    sessionContent = content;
  }

  @action
  onTap() {
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
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Observer(
                builder: (context) => SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: sessionContent.reversed.map((content) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              content,
                              style: GoogleFonts.jost(
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          );
                        }).toList(),
                      ),
                    )),
          ),
        ),
      ).whenComplete(() {
        nokhteBlur.reverse();
        setShowModal(false);
      });
    }
  }

  @observable
  String purpose = '';

  @action
  setPurpose(ObservableList<String> content) {
    nokhteBlur.setControl(Control.stop);
    setWidgetVisibility(false);
    Timer(Seconds.get(0, milli: 500), () {
      if (content.isEmpty) {
        purpose = 'No purpose yet';
      } else {
        sessionContent = content;
        purpose = content.last;
      }
      setWidgetVisibility(true);
    });
  }
}
