import 'package:equatable/equatable.dart';

class SkuProductEntity extends Equatable {
  final String period;
  final String currencyCode;
  final num price;
  const SkuProductEntity({
    required this.price,
    required this.period,
    required this.currencyCode,
  });

  @override
  List<Object> get props => [price, period, currencyCode];

  factory SkuProductEntity.initial() => const SkuProductEntity(
        price: -19.0,
        period: 'NO_PERIOD',
        currencyCode: 'NO_CURRENCY_CODE',
      );

  factory SkuProductEntity.fromSku(dynamic offering) {
    var premiumOffering = offering.all
        ?.singleWhere((offering) => offering.offeringId == 'nokhte_premium');
    final premiumSku = premiumOffering?.skus?.first.product;
    if (premiumSku != null) {
      return SkuProductEntity(
        period: premiumSku.period ?? 'NO_PRODUCT',
        currencyCode: premiumSku.currencyCode ?? 'NO_CURRENCY_CODE',
        price: premiumSku.price ?? -19.0,
      );
    } else {
      return SkuProductEntity.initial();
    }
  }
}
