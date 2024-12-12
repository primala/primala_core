import 'package:equatable/equatable.dart';

class CreateNewGroupParams extends Equatable {
  final String groupName;
  final String groupHandle;

  const CreateNewGroupParams({
    required this.groupName,
    required this.groupHandle,
  });

  @override
  List<Object> get props => [groupName, groupHandle];
}
