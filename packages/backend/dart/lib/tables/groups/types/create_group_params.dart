import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/types/types.dart';

class CreateGroupParams extends Equatable {
  final String groupName;
  final ProfileGradient profileGradient;

  CreateGroupParams({
    required this.groupName,
    required this.profileGradient,
  });

  @override
  List<Object> get props => [groupName, profileGradient];
}
