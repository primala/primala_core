// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/in_app_purchase/in_app_purchase.dart';
part 'in_app_purchase_coordinator.g.dart';

class InAppPurchaseCoordinator = _InAppPurchaseCoordinatorBase
    with _$InAppPurchaseCoordinator;

abstract class _InAppPurchaseCoordinatorBase with Store, BaseMobxLogic {
  final BuySubscription buySubscriptionLogic;
  final GetSubscriptionInfo getSubscriptionInfoLogic;

  _InAppPurchaseCoordinatorBase({
    required this.buySubscriptionLogic,
    required this.getSubscriptionInfoLogic,
  }) {
    initBaseLogicActions();
  }

  @observable
  SkuProductEntity skuProductEntity = SkuProductEntity.initial();

  @observable
  bool hasPurchasedSubscription = false;

  @override
  @action
  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (NetworkConnectionFailure):
        return FailureConstants.internetConnectionFailureMsg;
      case const (UserInputFailure):
        return FailureConstants.cancelledPurchaseFailureMsg;
      default:
        return FailureConstants.genericFailureMsg;
    }
  }

  @action
  getSubscriptionInfo() async {
    final res = await getSubscriptionInfoLogic(const NoParams());
    res.fold(
      (failure) => mapFailureToMessage(failure),
      (productInfo) => skuProductEntity = productInfo,
    );
  }

  @action
  buySubscription() async {
    final res = await buySubscriptionLogic(const NoParams());
    res.fold(
      (failure) => errorUpdater(failure),
      (result) => hasPurchasedSubscription = result,
    );
  }
}
