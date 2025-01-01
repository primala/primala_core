// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte_backend/types/types.dart';
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
  UserInformationEntity userInformation = UserInformationEntity.initial();

  @action
  getUserInformation() async {
    setState(StoreState.loading);
    final res = await contract.getUserInformation();
    res.fold((failure) => errorUpdater(failure), (userInformationEntity) {
      userInformation = userInformationEntity;
      setState(StoreState.loaded);
    });
  }

  @action
  checkIfVersionIsUpToDate() async {
    setState(StoreState.loading);
    final res = await contract.checkIfVersionIsUpToDate();
    res.fold((failure) => errorUpdater(failure),
        (status) => isOnMostRecentVersion = status);
    setState(StoreState.loaded);
  }
}
