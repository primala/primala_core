import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/types/types.dart';

class InitializeSessionParams extends Equatable {
  final UserEntities collaborators;
  final List<int> docIds;
  final int groupId;

  InitializeSessionParams({
    required this.collaborators,
    required this.docIds,
    required this.groupId,
  });

  @override
  List<Object> get props => [collaborators, docIds, groupId];
}
