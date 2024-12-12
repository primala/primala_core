// ignore_for_file: unused_import
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
export 'mobx/session_navigation_store.dart';
export 'widget/session_navigation.dart';

class SessionNavigationModule extends Module {
  @override
  List<Module> get imports => [
        GestureCrossModule(),
      ];
  @override
  void exportedBinds(Injector i) {
    i.add<SessionNavigationStore>(
      () => SessionNavigationStore(
        centerNokhte: CenterNokhteStore(),
        exitNokhte: AuxiliaryNokhteStore(),
        infoNokhte: AuxiliaryNokhteStore(),
        swipe: SwipeDetector(),
        swipeGuide: SwipeGuideStore(),
        tint: TintStore(),
        gestureCross: Modular.get<GestureCrossStore>(),
      ),
    );
  }
}
