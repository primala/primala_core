// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'group_display_modal_store.g.dart';

class GroupDisplayModalStore = _GroupDisplayModalStoreBase
    with _$GroupDisplayModalStore;

abstract class _GroupDisplayModalStoreBase extends BaseWidgetStore with Store {
  @observable
  GroupInformationEntity currentlySelectedGroup =
      GroupInformationEntity.empty();

  @action
  setCurrentlySelectedGroup(GroupInformationEntity group) =>
      currentlySelectedGroup = group;

  @observable
  GroupDisplayModalSection currentlySelectedSection =
      GroupDisplayModalSection.storage;

  @action
  setCurrentlySelectedSection(GroupDisplayModalSection section) =>
      currentlySelectedSection = section;

  @action
  resetValues() {
    currentlySelectedGroup = GroupInformationEntity.empty();
    currentlySelectedSection = GroupDisplayModalSection.storage;
  }
}
