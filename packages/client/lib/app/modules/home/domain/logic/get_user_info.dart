import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app//modules/home/domain/domain.dart';

class GetUserInfo
    implements AbstractFutureLogic<UserJourneyInfoEntity, NoParams> {
  final HomeContract contract;

  GetUserInfo({required this.contract});

  @override
  call(params) async => await contract.getUserInfo(params);
}
