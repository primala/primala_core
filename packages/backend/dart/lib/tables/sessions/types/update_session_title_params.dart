import 'package:equatable/equatable.dart';

class UpdateSessionTitleParams extends Equatable {
  final int sessionID;
  final String title;

  UpdateSessionTitleParams({
    required this.sessionID,
    required this.title,
  });

  @override
  List<Object> get props => [sessionID, title];
}
