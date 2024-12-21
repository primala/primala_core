import 'package:equatable/equatable.dart';

class InitializeSessionParams extends Equatable {
  final String groupUID;
  final String queueUID;

  const InitializeSessionParams({
    required this.groupUID,
    required this.queueUID,
  });

  @override
  List<Object> get props => [groupUID, queueUID];
}
