// ignore_for_file: must_be_immutable, library_private_types_in_public_api, annotate_overrides, overridden_fields
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/modules/posthog/constants/constants.dart';
import 'package:nokhte/app/core/modules/user_information/mobx/coordinators/user_information_coordinator.dart';
import 'package:nokhte/app/modules/home/presentation/mobx/mobx.dart';
import 'package:nokhte/app/modules/storage/domain/domain.dart';
part 'storage_guide_coordinator.g.dart';

class StorageGuideCoordinator = _StorageGuideCoordinatorBase
    with _$StorageGuideCoordinator;

abstract class _StorageGuideCoordinatorBase extends BaseHomeScreenCoordinator
    with Store {
  final StorageGuideWidgetsCoordinator widgets;
  final GetNokhteSessionArtifacts getNokhteSessionArtifactsLogic;
  final UserInformationCoordinator userInformation;

  _StorageGuideCoordinatorBase({
    required super.collaborationLogic,
    required super.swipe,
    required super.deepLinks,
    required this.widgets,
    required this.getNokhteSessionArtifactsLogic,
    required this.userInformation,
    required super.captureScreen,
    required super.tap,
  }) : super(widgets: widgets);

  @observable
  ObservableList<NokhteSessionArtifactEntity> nokhteSessionArtifacts =
      ObservableList();

  @override
  @action
  constructor(Offset offset) async {
    widgets.constructor(offset);
    initReactors();
    await captureScreen(Screens.storageGuideHome);
    await getNokhteSessionArtifacts();
  }

  @override
  initReactors() {
    super.initReactors();
    swipeReactor(
      onSwipeUp: () {
        setDisableAllTouchFeedback(true);
        widgets.onSwipeUp();
      },
      onSwipeRight: () async {
        setDisableAllTouchFeedback(true);
        widgets.onSwipeRight();
        await userInformation.updateHasEnteredStorageLogic(true);
      },
    );
    widgets.beachWavesMovieStatusReactor(
      onShoreToOceanDiveComplete: onShoreToOceanDiveComplete,
      onShoreToVibrantBlueComplete: onShoreToVibrantBlueComplete,
      onVirginStorageEntry: onVirginStorageEntry,
      onSubsequentStorageEntry: () {},
      onAnyToShoreComplete: () {
        setDisableAllTouchFeedback(false);
      },
    );
    swipeCoordinatesReactor(widgets.onSwipeCoordinatesChanged);
  }

  @action
  getNokhteSessionArtifacts() async {
    final res = await getNokhteSessionArtifactsLogic(NoParams());
    res.fold(
      (failure) => errorUpdater(failure),
      (artifacts) => nokhteSessionArtifacts = ObservableList.of(artifacts),
    );
  }

  @action
  onVirginStorageEntry() {
    Modular.to.navigate(
      '/storage/content',
      arguments: {
        "content": nokhteSessionArtifacts.first,
        "isFirstTime": true,
      },
    );
  }
}
