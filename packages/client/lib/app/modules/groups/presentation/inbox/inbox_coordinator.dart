// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
part 'inbox_coordinator.g.dart';

class InboxCoordinator = _InboxCoordinatorBase with _$InboxCoordinator;

abstract class _InboxCoordinatorBase with Store {
  final InboxWidgetsCoordinator widgets;

  _InboxCoordinatorBase({
    required this.widgets,
  });
}
