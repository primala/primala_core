// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
part 'lobby_coordinator.g.dart';

class LobbyCoordinator = _LobbyCoordinatorBase with _$LobbyCoordinator;

abstract class _LobbyCoordinatorBase with Store {
  @action
  constructor() {}
}
