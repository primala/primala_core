// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
part 'refresh_banner_store.g.dart';

class RefreshBannerStore = _RefreshBannerStoreBase with _$RefreshBannerStore;

abstract class _RefreshBannerStoreBase extends BaseWidgetStore with Store {
  _RefreshBannerStoreBase() {
    setWidgetVisibility(false);
    Timer(Seconds.get(0, milli: 1), () {
      setWidgetVisibility(true);
    });
  }
}
