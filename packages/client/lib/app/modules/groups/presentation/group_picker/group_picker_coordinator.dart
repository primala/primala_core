// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'group_picker_coordinator.g.dart';

class GroupPickerCoordinator = _GroupPickerCoordinatorBase
    with _$GroupPickerCoordinator;

abstract class _GroupPickerCoordinatorBase
    with Store, BaseMobxLogic, Reactions {
  final GroupPickerWidgetsCoordinator widgets;
  final GroupsContractImpl contract;

  _GroupPickerCoordinatorBase({
    required this.widgets,
    required this.contract,
  }) {
    initBaseLogicActions();
  }

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    await getGroups();
  }

  initReactors() {
    disposers.add(groupsReactor());
    disposers.add(widgets.createGroupReactor());
  }

  @observable
  ObservableList<GroupEntity> groups = ObservableList<GroupEntity>();

  @action
  getGroups() async {
    final res = await contract.getGroups();
    res.fold(
      (failure) => errorUpdater(failure),
      (incomingGroups) => groups = ObservableList.of(incomingGroups),
    );
  }

  groupsReactor() => reaction((p0) => groups, (p0) {
        widgets.groupDisplay.setGroups(p0);
        widgets.groupDisplay.setWidgetVisibility(true);
      });
}
