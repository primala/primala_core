// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
part 'session_bar_store.g.dart';

class SessionBarStore = _SessionBarStoreBase with _$SessionBarStore;

abstract class _SessionBarStoreBase extends BaseWidgetStore with Store {
  _SessionBarStoreBase() {
    setWidgetVisibility(false);
    Timer(Seconds.get(0, milli: 1), () {
      setWidgetVisibility(true);
    });
  }
}
