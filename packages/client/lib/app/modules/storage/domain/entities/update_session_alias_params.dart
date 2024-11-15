import 'package:equatable/equatable.dart';

class UpdateSessionAliasParams extends Equatable {
  final String sessionUID;
  final String newAlias;
  const UpdateSessionAliasParams({
    required this.sessionUID,
    required this.newAlias,
  });

  @override
  List<Object> get props => [sessionUID, newAlias];
}
