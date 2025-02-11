import 'package:equatable/equatable.dart';

class UpdateGroupNameParams extends Equatable {
  final int groupId;
  final String name;

  UpdateGroupNameParams({
    required this.groupId,
    required this.name,
  });

  @override
  List<Object> get props => [groupId, name];
}
