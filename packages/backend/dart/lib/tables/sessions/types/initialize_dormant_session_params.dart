import 'package:equatable/equatable.dart';

class InitializeDormantSessionParams extends Equatable {
  final String groupUID;
  final String title;

  InitializeDormantSessionParams({
    required this.groupUID,
    required this.title,
  });

  @override
  List<Object> get props => [groupUID, title];
}
