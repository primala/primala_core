// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
part 'smart_text_store.g.dart';

class SmartTextStore = _SmartTextStoreBase with _$SmartTextStore;

abstract class _SmartTextStoreBase extends BaseWidgetStore with Store {}
