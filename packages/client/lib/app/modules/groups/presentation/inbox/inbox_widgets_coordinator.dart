// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'inbox_widgets_coordinator.g.dart';

class InboxWidgetsCoordinator = _InboxWidgetsCoordinatorBase
    with _$InboxWidgetsCoordinator;

abstract class _InboxWidgetsCoordinatorBase with Store {
  final AnimatedScaffoldStore animatedScaffold;

  _InboxWidgetsCoordinatorBase({
    required this.animatedScaffold,
  });
}
