import 'package:equatable/equatable.dart';

class UpdateGroupMemberParams extends Equatable {
  final String groupId;
  final List<String> members;
  final bool isAdding;

  const UpdateGroupMemberParams({
    required this.groupId,
    required this.members,
    required this.isAdding,
  });

  @override
  List<Object> get props => [groupId, members, isAdding];
}
