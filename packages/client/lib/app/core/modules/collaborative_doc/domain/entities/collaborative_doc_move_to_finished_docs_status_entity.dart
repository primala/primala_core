import 'package:nokhte/app/core/entities/default_db_status_entity.dart';

class CollaborativeDocMoveToFinishedDocsStatusEntity
    extends DefaultDBStatusEntity {
  const CollaborativeDocMoveToFinishedDocsStatusEntity({required bool isMoved})
      : super(isSent: isMoved);
}
