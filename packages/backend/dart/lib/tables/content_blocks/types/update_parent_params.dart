import 'package:equatable/equatable.dart';

class UpdateParentParams extends Equatable {
  final String parentUID;
  final String uid;

  UpdateParentParams({
    required this.uid,
    required this.parentUID,
  });

  factory UpdateParentParams.initial() => UpdateParentParams(
        uid: '',
        parentUID: '',
      );

  @override
  List<Object> get props => [
        uid,
        parentUID,
      ];
}
