// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
part 'settings_layout_store.g.dart';

class SettingsLayoutStore = _SettingsLayoutStoreBase with _$SettingsLayoutStore;

abstract class _SettingsLayoutStoreBase extends BaseWidgetStore with Store {
  @observable
  String fullName = '';

  @action
  setFullName(String value) => fullName = value;

  @action
  onTap() {
    print('tap count: $tapCount');
    return tapCount++;
  }

  @observable
  bool isExpanded = false;

  @action
  setIsExpanded(bool value) => isExpanded = value;
}
