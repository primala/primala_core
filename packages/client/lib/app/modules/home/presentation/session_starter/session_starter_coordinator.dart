// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/modules/home/home.dart';
part 'session_starter_coordinator.g.dart';

class SessionStarterCoordinator = _SessionStarterCoordinatorBase
    with _$SessionStarterCoordinator;

abstract class _SessionStarterCoordinatorBase with Store, BaseMobxLogic {
  final HomeContract contract;

  _SessionStarterCoordinatorBase({
    required this.contract,
  });

  @action
  constructor() {}

  @action
  initializeSession() async {
    // final res = await contract.initializeSession();
    // res.fold((failure) => errorUpdater(failure), (success) {
    //   // TODO navigate inside session
    // });
  }
}
