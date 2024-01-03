import 'package:nokhte/app/modules/home/domain/domain.dart';

class HasSentAnInvitationUpdateStatusModel
    extends HasSentAnInvitationUpdateStatusEntity {
  const HasSentAnInvitationUpdateStatusModel({
    required super.isUpdated,
  });

  factory HasSentAnInvitationUpdateStatusModel.fromSupabase(List res) {
    if (res.isEmpty) {
      return const HasSentAnInvitationUpdateStatusModel(isUpdated: false);
    } else {
      return const HasSentAnInvitationUpdateStatusModel(isUpdated: true);
    }
  }
}
