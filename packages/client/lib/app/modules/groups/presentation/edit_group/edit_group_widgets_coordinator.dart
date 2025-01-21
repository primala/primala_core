// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'edit_group_widgets_coordinator.g.dart';

class EditGroupWidgetsCoordinator = _EditGroupWidgetsCoordinatorBase
    with _$EditGroupWidgetsCoordinator;

abstract class _EditGroupWidgetsCoordinatorBase with Store {
  final AnimatedScaffoldStore animatedScaffold;

  _EditGroupWidgetsCoordinatorBase({
    required this.animatedScaffold,
  });
}
