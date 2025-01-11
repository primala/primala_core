import 'package:equatable/equatable.dart';

class UpdateSessionTitleParams extends Equatable {
  final String sessionUID;
  final String title;

  UpdateSessionTitleParams({
    required this.sessionUID,
    required this.title,
  });

  @override
  List<Object> get props => [sessionUID, title];
}
