export 'storage_guide_coordinator.dart';
export 'storage_guide_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';

class StorageGuideScreen extends BaseHomeScreen {
  StorageGuideScreen({
    super.key,
    required StorageGuideCoordinator coordinator,
  }) : super(
          coordinator: coordinator,
          gestureCrossConfig: coordinator.widgets.gestureCrossConfig,
          instructionalNokhtes: Stack(
            children: [
              SwipeGuide(
                toTheRight: false,
                store: coordinator.widgets.swipeGuide,
              ),
              CenterInstructionalNokhte(
                store: coordinator.widgets.centerInstructionalNokhte,
              ),
              InstructionalGradientNokhte(
                store: coordinator.widgets.sessionStarterInstructionalNokhte,
              ),
              InstructionalGradientNokhte(
                store: coordinator.widgets.storageInstructionalNokhte,
              ),
            ],
          ),
        );
}
