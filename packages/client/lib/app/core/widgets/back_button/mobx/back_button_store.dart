// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
part 'back_button_store.g.dart';

class BackButtonStore = _BackButtonStoreBase with _$BackButtonStore;

abstract class _BackButtonStoreBase extends BaseWidgetStore with Store {
  @action
  onTap() {
    tapCount++;
  }
}
