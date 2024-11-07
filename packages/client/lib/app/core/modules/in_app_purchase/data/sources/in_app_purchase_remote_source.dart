// import 'package:glassfy_flutter/glassfy_flutter.dart';
// import 'package:glassfy_flutter/models.dart';

abstract class InAppPurchaseRemoteSource {
  Future<dynamic> getSubscriptionInfo();
  Future<bool> buySubscription();
}

class InAppPurchaseRemoteSourceImpl implements InAppPurchaseRemoteSource {
  @override
  getSubscriptionInfo() async => throw UnimplementedError();

  @override
  buySubscription() async {
    return false;
  }
}
