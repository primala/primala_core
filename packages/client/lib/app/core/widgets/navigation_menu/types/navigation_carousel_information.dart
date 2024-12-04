import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class NavigationCarouselInformation extends Equatable {
  final List<GradientConfig> gradients;
  final List<String> labels;
  final List<String> routes;

  const NavigationCarouselInformation({
    required this.gradients,
    required this.labels,
    required this.routes,
  });

  @override
  List<Object> get props => [
        gradients,
        labels,
        routes,
      ];
}
