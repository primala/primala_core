// ignore_for_file: must_be_immutable, library_private_types_in_public_api
// * Mobx Import
import 'package:mobx/mobx.dart';
// * Equatable Import
import 'package:primala/app/core/widgets/text_editors/mobx.dart';
// * Mobx Codegen Inclusion
part 'user_text_editor_tracker_store.g.dart';

class UserTextEditorTrackerStore = _UserTextEditorTrackerStoreBase
    with _$UserTextEditorTrackerStore;

abstract class _UserTextEditorTrackerStoreBase extends BaseTextEditorStore
    with Store {
  @override
  List<Object> get props => [
// some items
      ];
}
