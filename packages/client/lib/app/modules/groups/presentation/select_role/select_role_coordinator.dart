// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'select_role_coordinator.g.dart';

class SelectRoleCoordinator = _SelectRoleCoordinatorBase
    with _$SelectRoleCoordinator;

abstract class _SelectRoleCoordinatorBase with Store {
  final SelectRoleWidgetsCoordinator widgets;

  _SelectRoleCoordinatorBase({
    required this.widgets,
  });
}
