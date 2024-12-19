import 'package:equatable/equatable.dart';

class CollaboratorRelationshipEntity extends Equatable {
  final String uid;
  final String fullName;

  CollaboratorRelationshipEntity({
    required this.uid,
    required this.fullName,
  });

  @override
  List<Object> get props => [uid, fullName];
}
