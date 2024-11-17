// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/base_widget_store.dart';
import 'package:nokhte/app/core/types/types.dart';
part 'purpose_banner_store.g.dart';

class PurposeBannerStore = _PurposeBannerStoreBase with _$PurposeBannerStore;

abstract class _PurposeBannerStoreBase extends BaseWidgetStore<NoParams>
    with Store {
  @observable
  String purpose = '';

  @action
  setPurpose(String purpose) {
    setWidgetVisibility(false);
    Timer(Seconds.get(0, milli: 500), () {
      if (purpose.isEmpty) {
        this.purpose = 'No purpose yet';
      } else {
        this.purpose = purpose;
      }
      setWidgetVisibility(true);
    });
  }
}
