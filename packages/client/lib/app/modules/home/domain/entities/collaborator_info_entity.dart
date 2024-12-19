import 'package:equatable/equatable.dart';

class CollaboratorInfoEntity extends Equatable {
  final String fullName;
  final String userUID;

  const CollaboratorInfoEntity({
    required this.fullName,
    required this.userUID,
  });

  @override
  List<Object> get props => [fullName, userUID];
}
