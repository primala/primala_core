// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';

mixin BaseWidgetsCoordinator {
  final _showWidgets = Observable(false);

  bool get showWidgets => _showWidgets.value;

  _setShowWidgets(bool value) => _showWidgets.value = value;

  Action actionSetShowWidgets = Action(() {});

  setShowWidgets(bool value) {
    actionSetShowWidgets([value]);
  }

  initBaseWidgetsCoordinatorActions() {
    actionSetShowWidgets = Action(_setShowWidgets);
  }
}
