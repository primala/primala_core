// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'select_role_widgets_coordinator.g.dart';

class SelectRoleWidgetsCoordinator = _SelectRoleWidgetsCoordinatorBase
    with _$SelectRoleWidgetsCoordinator;

abstract class _SelectRoleWidgetsCoordinatorBase with Store {
  final AnimatedScaffoldStore animatedScaffold;

  _SelectRoleWidgetsCoordinatorBase({
    required this.animatedScaffold,
  });
}
