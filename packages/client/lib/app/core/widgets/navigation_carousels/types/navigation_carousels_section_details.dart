import 'package:equatable/equatable.dart';

enum NavigationCarouselsSectionTypes { cameraIcon, qrCodeIcon, queueIcon }

class NavigationCarouselsSectionDetails extends Equatable {
  final NavigationCarouselsSectionTypes type;
  late final String assetPath;

  NavigationCarouselsSectionDetails(
    this.type,
  ) {
    _assignAssetPath(type);
  }

  _assignAssetPath(
    NavigationCarouselsSectionTypes type,
  ) {
    switch (type) {
      case NavigationCarouselsSectionTypes.cameraIcon:
        assetPath = 'assets/home/camera_icon.png';
      case NavigationCarouselsSectionTypes.qrCodeIcon:
        assetPath = 'assets/home/qr_code_icon.png';
      case NavigationCarouselsSectionTypes.queueIcon:
        assetPath = 'assets/groups/queue_icon.png';
    }
  }

  @override
  List<Object> get props => [type];
}
