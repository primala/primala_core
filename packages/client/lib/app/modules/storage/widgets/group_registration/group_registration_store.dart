// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'group_registration_store.g.dart';

class GroupRegistrationStore = _GroupRegistrationStoreBase
    with _$GroupRegistrationStore;

abstract class _GroupRegistrationStoreBase extends BaseWidgetStore with Store {
  @observable
  String groupName = '';

  @observable
  String groupHandle = '';

  @observable
  int submissionCount = 0;

  @action
  setGroupName(String name) => groupName = name;

  @action
  setGroupHandle(String handle) => groupHandle = handle;

  @action
  onSubmit() {
    if (groupName.isEmpty || groupHandle.isEmpty) return;
    submissionCount++;
    setWidgetVisibility(false);
  }

  @computed
  CreateNewGroupParams get params => CreateNewGroupParams(
        groupName: groupName,
        groupHandle: groupHandle,
      );
}
