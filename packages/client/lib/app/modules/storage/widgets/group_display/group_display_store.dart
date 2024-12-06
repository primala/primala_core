// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'group_display_store.g.dart';

class GroupDisplayStore = _GroupDisplayStoreBase with _$GroupDisplayStore;

abstract class _GroupDisplayStoreBase extends BaseWidgetStore with Store {
  final NokhteBlurStore blur;

  _GroupDisplayStoreBase({
    required this.blur,
  });

  constructor() {
    setWidgetVisibility(false);
  }

  @action
  onGroupsReceived(List<GroupInformationEntity> groups) {
    this.groups = ObservableList.of(groups);
    setWidgetVisibility(true);
  }

  @observable
  ObservableList<GroupInformationEntity> groups = ObservableList.of([]);

  @observable
  bool isDragging = false;

  @observable
  bool showModal = false;

  @observable
  int successfulDragsCount = 0;

  @observable
  String groupUIDToDelete = '';

  @action
  setIsDragging(bool value) => isDragging = value;

  @action
  setShowModal(bool value) => showModal = value;

  @action
  onDragAccepted(GroupInformationEntity group) {
    successfulDragsCount++;
    groupUIDToDelete = group.groupUID;
    setIsDragging(false);
  }

  @action
  onTap() {
    if (isDragging || !showWidget) return;
    incrementTapCount();
    setWidgetVisibility(false);
  }
}
