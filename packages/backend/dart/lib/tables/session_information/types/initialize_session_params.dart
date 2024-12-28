import 'package:equatable/equatable.dart';

class InitializeSessionParams extends Equatable {
  final String groupUID;
  final String sessionUID;

  const InitializeSessionParams({
    required this.groupUID,
    this.sessionUID = '',
  });

  @override
  List<Object> get props => [groupUID, sessionUID];
}
