// ignore_for_file: must_be_immutable, library_private_types_in_public_api, empty_catches
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/clean_up_sessions/clean_up_sessions.dart';
part 'clean_up_sessions_coordinator.g.dart';

class CleanUpSessionsCoordinator = _CleanUpSessionsCoordinatorBase
    with _$CleanUpSessionsCoordinator;

abstract class _CleanUpSessionsCoordinatorBase
    with Store, BaseMobxLogic<NoParams, bool> {
  final CleanUpSessionsContract contract;

  _CleanUpSessionsCoordinatorBase({
    required this.contract,
  }) {
    initBaseLogicActions();
  }

  @override
  @action
  Future<void> call(NoParams params) async {
    try {
      setState(StoreState.loading);
      // await sessionStarters.nuke();
      await contract.cleanUpNokhteSession(const NoParams());
      setState(StoreState.loaded);
    } catch (e) {}
  }
}
