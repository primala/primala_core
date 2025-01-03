// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/session_content/session_content.dart';
import 'package:nokhte_backend/tables/session_content.dart';
part 'block_text_display_store.g.dart';

class BlockTextDisplayStore = _BlockTextDisplayStoreBase
    with _$BlockTextDisplayStore;

abstract class _BlockTextDisplayStoreBase extends BaseWidgetStore with Store {
  final BlockTextFieldsStore blockTextFields;

  _BlockTextDisplayStoreBase({
    required this.blockTextFields,
  });

  @observable
  ObservableList<double> swipeProgresses = ObservableList<double>();

  @action
  setSwipeProgress(double val, int index) => swipeProgresses[index] = val;

  @observable
  ObservableList<SessionContentEntity> content =
      ObservableList<SessionContentEntity>();

  @action
  onParentSelected(String itemUID) {
    blockTextFields.setCurrentlySelectedParentUID(itemUID);
    blockTextFields.focusNode.requestFocus();
  }

  @action
  setContent(ObservableList<SessionContentEntity> newContent) {
    content = newContent;
    swipeProgresses =
        ObservableList<double>.of(List.generate(content.length, (index) => 0));
  }

  @action
  clear() {
    content = ObservableList<SessionContentEntity>();
  }

  @action
  onSubmit() {
    blockTextFields.onSubmit();
  }
}
