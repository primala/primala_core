// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/base_widget_store.dart';
part 'pause_icon_store.g.dart';

class PauseIconStore = _PauseIconStoreBase with _$PauseIconStore;

abstract class _PauseIconStoreBase extends BaseWidgetStore<NoParams>
    with Store {}
