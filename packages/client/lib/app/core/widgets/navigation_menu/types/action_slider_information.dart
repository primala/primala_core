import 'package:equatable/equatable.dart';

class ActionSliderInformation extends Equatable {
  final String assetPath;
  final String sliderText;
  final Function callback;

  const ActionSliderInformation({
    required this.assetPath,
    required this.sliderText,
    required this.callback,
  });

  @override
  List<Object> get props => [
        assetPath,
        sliderText,
        callback,
      ];
}
