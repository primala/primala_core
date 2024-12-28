// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
part 'purpose_with_conclusions_store.g.dart';

class PurposeWithConclusionsStore = _PurposeWithConclusionsStoreBase
    with _$PurposeWithConclusionsStore;

abstract class _PurposeWithConclusionsStoreBase extends BaseWidgetStore
    with Store {
  @observable
  double swipeProgress = 0;

  @action
  setSwipeProgress(double val) => swipeProgress = val;
}
