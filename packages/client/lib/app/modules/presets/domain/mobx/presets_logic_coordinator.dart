// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
part 'presets_logic_coordinator.g.dart';

class PresetsLogicCoordinator = _PresetsLogicCoordinatorBase
    with _$PresetsLogicCoordinator;

abstract class _PresetsLogicCoordinatorBase with Store, BaseMobxLogic {
  final PresetsContract contract;

  _PresetsLogicCoordinatorBase({
    required this.contract,
  }) {
    initBaseLogicActions();
  }

  @observable
  CompanyPresetsEntity presetsEntity = CompanyPresetsEntity.initial();

  @observable
  bool preferencesAreUpdated = false;

  @action
  reset() {
    presetsEntity = CompanyPresetsEntity.initial();
    preferencesAreUpdated = false;
  }

  @action
  getCompanyPresets(
    Either<GetAllPresetsParams, String> params,
  ) async {
    setState(StoreState.loading);
    final result = await contract.getPresets(params);
    result.fold((failure) => errorUpdater(failure), (entity) {
      presetsEntity = entity;
      setState(StoreState.loaded);
    });
  }

  @action
  upsertSessionPreferences(UpsertSessionPreferencesParams params) async {
    final result = await contract.upsertSessionPreferences(params);
    result.fold((failure) => errorUpdater(failure), (updateStatus) {
      preferencesAreUpdated = updateStatus;
    });
  }
}
