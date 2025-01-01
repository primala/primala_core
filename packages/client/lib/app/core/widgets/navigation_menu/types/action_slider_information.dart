// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class ActionSliderInformation extends Equatable {
  final ActionSliderOptions actionSliderOption;
  late final String assetPath;
  late final String sliderText;
  ActionSliderInformation({
    required this.actionSliderOption,
  }) {
    _initializeSliderDetails();
  }

  void _initializeSliderDetails() {
    switch (actionSliderOption) {
      case ActionSliderOptions.startSession:
        assetPath = 'assets/qr_code_icon.png';
        sliderText = 'Start Session';
      // case ActionSliderOptions.joinSession:
      //   assetPath = 'assets/camera_icon.png';
      //   sliderText = 'Join Session';
      case ActionSliderOptions.homeScreen:
        assetPath = 'assets/session/home_beach_icon.png';
        sliderText = 'Home Screen';
        break;
      case ActionSliderOptions.sessionInformation:
        assetPath = 'assets/session/session_information_icon.png';
        sliderText = 'Session Information';
        break;
      case ActionSliderOptions.endSession:
        assetPath = 'assets/session/end_session_icon.png';
        sliderText = 'End Session';
        break;
      case ActionSliderOptions.pauseSession:
        assetPath = 'assets/session/pause_icon.png';
        sliderText = 'Pause Session';
        break;
      case ActionSliderOptions.none:
        assetPath = '';
        sliderText = '';
    }
  }

  @override
  List<Object> get props => [actionSliderOption];
}
