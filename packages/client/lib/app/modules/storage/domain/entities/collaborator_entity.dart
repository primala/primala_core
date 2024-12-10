import 'package:equatable/equatable.dart';

class CollaboratorEntity extends Equatable {
  final String uid;
  final String name;
  final bool isAMember;

  const CollaboratorEntity({
    required this.uid,
    required this.name,
    required this.isAMember,
  });

  @override
  List<Object> get props => [uid, name, isAMember];
}
