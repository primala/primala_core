// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
part 'user_information_coordinator.g.dart';

class UserInformationCoordinator = _UserInformationCoordinatorBase
    with _$UserInformationCoordinator;

abstract class _UserInformationCoordinatorBase with Store, BaseMobxLogic {
  final UserInformationContract contract;

  _UserInformationCoordinatorBase({
    required this.contract,
  }) {
    initBaseLogicActions();
  }

  @observable
  bool isOnMostRecentVersion = false;

  @observable
  bool presetIsUpdated = false;

  @observable
  PreferredPresetEntity preferredPreset = PreferredPresetEntity.initial();

  @action
  getPreferredPreset() async {
    setState(StoreState.loading);
    final res = await contract.getPreferredPreset(const NoParams());
    res.fold((failure) => errorUpdater(failure), (presetInfo) {
      preferredPreset = presetInfo;
      setState(StoreState.loaded);
    });
  }

  @action
  updatePreferredPreset(String presetUID) async {
    setState(StoreState.loading);
    final res = await contract.updatePreferredPreset(presetUID);
    res.fold((failure) => errorUpdater(failure),
        (status) => presetIsUpdated = status);
    setState(StoreState.loaded);
  }

  @action
  checkIfVersionIsUpToDate() async {
    setState(StoreState.loading);
    final res = await contract.checkIfVersionIsUpToDate();
    res.fold((failure) => errorUpdater(failure),
        (status) => isOnMostRecentVersion = status);
    setState(StoreState.loaded);
  }

  @computed
  bool get hasAccessedQrCode => preferredPreset.name.isNotEmpty;
}
