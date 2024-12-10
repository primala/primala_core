// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'queue_creation_modal_store.g.dart';

class QueueCreationModalStore = _QueueCreationModalStoreBase
    with _$QueueCreationModalStore;

abstract class _QueueCreationModalStoreBase extends BaseWidgetStore with Store {
  final NokhteBlurStore blur;

  _QueueCreationModalStoreBase({
    required this.blur,
  });

  @observable
  bool showModal = false;

  @action
  setShowModal(bool value) => showModal = value;

  void showGroupDetailsModal(BuildContext context) {
    if (showModal) return;
    blur.init(end: Seconds.get(0, milli: 200));
    showModalBottomSheet(
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(36),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(.2),
      context: context,
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
                  child: SingleChildScrollView(
                      // child:
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      blur.reverse();
      setShowModal(false);
    });
  }
}
