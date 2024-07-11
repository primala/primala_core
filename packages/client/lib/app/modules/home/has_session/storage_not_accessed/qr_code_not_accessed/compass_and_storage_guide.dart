export 'compass_and_storage_guide_coordinator.dart';
export 'compass_and_storage_guide_widgets_coordinator.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';

class CompassAndStorageGuideScreen extends BaseHomeScreen {
  CompassAndStorageGuideScreen({
    super.key,
    required CompassAndStorageGuideCoordinator coordinator,
  }) : super(
          coordinator: coordinator,
          gestureCrossConfig: GestureCrossConfiguration(
            right: Right(
              NokhteGradientConfig(
                gradientType: NokhteGradientTypes.storage,
              ),
            ),
          ),
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
                store: coordinator.widgets.focusInstructionalNokhte,
              ),
            ],
          ),
        );
}
