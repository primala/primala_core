// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'group_display_collaborator_card_store.g.dart';

class GroupDisplayCollaboratorCardStore = _GroupDisplayCollaboratorCardStoreBase
    with _$GroupDisplayCollaboratorCardStore;

abstract class _GroupDisplayCollaboratorCardStoreBase extends BaseWidgetStore
    with Store {
  @observable
  ObservableList<bool> membershipList = ObservableList<bool>();

  @observable
  ObservableList<CollaboratorEntity> collaborators =
      ObservableList<CollaboratorEntity>();

  @action
  setCollaborators(List<CollaboratorEntity> collaborators) {
    this.collaborators = ObservableList.of(collaborators);
    membershipList.clear();
    for (var collaborator in collaborators) {
      membershipList.add(collaborator.isAMember);
    }
  }

  @action
  toggleMembershipStatus(int index) {
    if (index >= 0 && index < membershipList.length) {
      membershipList[index] = !membershipList[index];
    }
    print('members to add ${membersToAdd}');
    print('members to remove ${membersToRemove}');
  }

  @computed
  List<String> get membersToAdd {
    List<String> toAdd = [];
    for (int i = 0; i < collaborators.length; i++) {
      if (membershipList[i] && !collaborators[i].isAMember) {
        toAdd.add(collaborators[i].uid);
      }
    }
    return toAdd;
  }

  @computed
  List<String> get membersToRemove {
    List<String> toRemove = [];
    for (int i = 0; i < collaborators.length; i++) {
      if (!membershipList[i] && collaborators[i].isAMember) {
        toRemove.add(collaborators[i].uid);
      }
    }
    return toRemove;
  }
}
