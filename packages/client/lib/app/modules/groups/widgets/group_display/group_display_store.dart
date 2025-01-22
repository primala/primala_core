// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
part 'group_display_store.g.dart';

class GroupDisplayStore = _GroupDisplayStoreBase with _$GroupDisplayStore;

abstract class _GroupDisplayStoreBase extends BaseWidgetStore with Store {
  @observable
  ObservableList groups = ObservableList.of([]);
}
