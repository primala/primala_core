import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/sessions.dart';

class InitializeSessionParams extends Equatable {
  final List<SessionUserEntity> collaborators;
  final List<int> documentIds;
  final int groupId;

  InitializeSessionParams({
    required this.collaborators,
    required this.documentIds,
    required this.groupId,
  });

  @override
  List<Object> get props => [collaborators, documentIds, groupId];
}
