import 'package:equatable/equatable.dart';

class GetQueueParams extends Equatable {
  final String groupId;
  final String uid;

  GetQueueParams({
    this.groupId = '',
    this.uid = '',
  }) {
    assert(
      (uid.isEmpty && groupId.isNotEmpty) ||
          (uid.isNotEmpty && groupId.isEmpty),
      'Either uid or groupId must be provided but not both',
    );
  }

  @override
  List<Object> get props => [groupId, uid];
}
