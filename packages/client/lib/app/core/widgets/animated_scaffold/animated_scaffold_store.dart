// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'animated_scaffold_store.g.dart';

class AnimatedScaffoldStore = _AnimatedScaffoldStoreBase
    with _$AnimatedScaffoldStore;

abstract class _AnimatedScaffoldStoreBase extends BaseWidgetStore
    with Store, AnimatedScaffoldMovie {
  _AnimatedScaffoldStoreBase() {
    setMovie(getMovie(Colors.black, const Color(0xFFFFFBEC)));
  }
}
