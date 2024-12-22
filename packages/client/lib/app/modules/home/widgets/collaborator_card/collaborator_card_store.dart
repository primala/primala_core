// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte_backend/types/types.dart';
part 'collaborator_card_store.g.dart';

class CollaboratorCardStore = _CollaboratorCardStoreBase
    with _$CollaboratorCardStore;

abstract class _CollaboratorCardStoreBase extends BaseWidgetStore with Store {
  @observable
  ObservableList<bool> membershipList = ObservableList<bool>();

  @observable
  ObservableList<UserInformationEntity> collaborators =
      ObservableList<UserInformationEntity>.of([
    UserInformationEntity(
      uid: '',
      fullName: 'No Collaborators',
    ),
  ]);

  @action
  setCollaborators(List<UserInformationEntity> collaborators) {
    if (collaborators.isEmpty) return;
    this.collaborators = ObservableList.of(collaborators);
  }
}
