import 'package:equatable/equatable.dart';

class JoinSessionParams extends Equatable {
  final int userIndex;
  final String sessionUID;

  const JoinSessionParams({
    required this.userIndex,
    required this.sessionUID,
  });

  @override
  List<Object> get props => [userIndex, sessionUID];
}
