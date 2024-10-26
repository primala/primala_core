// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/base_widget_store.dart';
part 'nokhte_gradient_text_store.g.dart';

class NokhteGradientTextStore = _NokhteGradientTextStoreBase
    with _$NokhteGradientTextStore;

abstract class _NokhteGradientTextStoreBase extends BaseWidgetStore with Store {
  @action
  onTap() {
    tapCount++;
  }
}
