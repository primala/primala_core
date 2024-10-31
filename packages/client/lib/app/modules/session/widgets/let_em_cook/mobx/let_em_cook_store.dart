// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:simple_animations/simple_animations.dart';
part 'let_em_cook_store.g.dart';

class LetEmCookStore = _LetEmCookStoreBase with _$LetEmCookStore;

abstract class _LetEmCookStoreBase extends BaseWidgetStore with Store {
  @observable
  String currentCook = '';

  @action
  setCurrentCook(String cook) => currentCook = cook;

  @observable
  bool buttonVisibility = false;

  @action
  setButtonVisibility(bool visibility) => buttonVisibility = visibility;

  @observable
  bool sentAnimationVisibility = false;

  @action
  setSentAnimationVisibility(bool visibility) {
    setControl(Control.stop);
    sentAnimationVisibility = visibility;
  }

  @action
  initSentAnimation() {
    setButtonVisibility(false);
    setControl(Control.playReverseFromEnd);
    setControl(Control.stop);
    Timer(Seconds.get(1), () {
      setControl(Control.playFromStart);
    });
  }

  @action
  onTap() {
    if (buttonVisibility) {
      tapCount++;
    }
  }
}
