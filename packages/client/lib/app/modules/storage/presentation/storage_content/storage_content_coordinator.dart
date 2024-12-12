// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'storage_content_coordinator.g.dart';

class StorageContentCoordinator = _StorageContentCoordinatorBase
    with _$StorageContentCoordinator;

abstract class _StorageContentCoordinatorBase with Store, BaseCoordinator {
  final StorageContentWidgetsCoordinator widgets;
  @override
  final CaptureScreen captureScreen;
  _StorageContentCoordinatorBase({
    required this.captureScreen,
    required this.widgets,
  }) {
    initBaseCoordinatorActions();
  }

  @observable
  SessionArtifactEntity nokhteSessionArtifacts =
      SessionArtifactEntity.initial();

  @observable
  bool aliasIsUpdated = false;

  @action
  constructor() async {
    if (Modular.args.data["content"] != null) {
      nokhteSessionArtifacts = Modular.args.data["content"];
    }
    widgets.constructor();
    await captureScreen(StorageConstants.content);
  }

  deconstructor() {
    widgets.dispose();
  }
}
