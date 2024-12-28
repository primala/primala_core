// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
part 'block_text_fields_store.g.dart';

class BlockTextFieldsStore = _BlockTextFieldsStoreBase
    with _$BlockTextFieldsStore;

abstract class _BlockTextFieldsStoreBase extends BaseWidgetStore with Store {}
