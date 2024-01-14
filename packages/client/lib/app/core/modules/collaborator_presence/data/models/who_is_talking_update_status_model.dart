import 'package:nokhte/app/core/modules/collaborator_presence/domain/domain.dart';

class WhoIsTalkingUpdateStatusModel extends WhoIsTalkingUpdateStatusEntity {
  const WhoIsTalkingUpdateStatusModel({required super.isUpdated});

  static WhoIsTalkingUpdateStatusModel fromSupabase(List res) {
    if (res.isEmpty) {
      return const WhoIsTalkingUpdateStatusModel(isUpdated: false);
    } else {
      return const WhoIsTalkingUpdateStatusModel(isUpdated: true);
    }
  }
}
