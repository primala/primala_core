// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/logic/types/types.dart';
import 'package:nokhte/app/modules/session/widgets/widgets.dart';
part 'rally_store.g.dart';

class RallyStore = _RallyStoreBase with _$RallyStore;

abstract class _RallyStoreBase extends BaseWidgetStore with Store, Reactions {
  final TintStore tint;
  final BackButtonStore backButton;

  _RallyStoreBase({
    required this.tint,
    required this.backButton,
  }) {
    setWidgetVisibility(false);
  }

  @action
  constructor() {
    tint.startAtEnd();
    disposers.add(backButtonTapReactor());
    disposers.add(glowColorReactor());
  }

  setValues({
    required List<String> fullNames,
    required List<bool> canRally,
  }) {
    setCollaborators(fullNames);
    setCanRally(canRally);
  }

  @observable
  RallyPhase phase = RallyPhase.initial;

  @observable
  bool cancelButtonVisibility = true;

  @observable
  ObservableList<String> collaborators = ObservableList.of([]);

  @observable
  ObservableList<bool> canRally = ObservableList.of([]);

  @observable
  int currentlySelectedIndex = -1;

  @observable
  String currentInitiatorFirstName = '';

  @observable
  GlowColor glowColor = GlowColor.transparent;

  @action
  setGlowColor(GlowColor value) => glowColor = value;

  @action
  setCancelButtonVisibility(bool value) => cancelButtonVisibility = value;

  @action
  setCurrentlySelectedIndex(int value) {
    if (currentlySelectedIndex == -1) {
      currentlySelectedIndex = value;
      setRallyPhase(RallyPhase.activeInitiator);
    }
  }

  @action
  setCollaborators(List<String> value) =>
      collaborators = ObservableList.of(value);

  @action
  setCurrentInitiator(String value) => currentInitiatorFirstName = value;

  @action
  setCanRally(List<bool> value) => canRally = ObservableList.of(value);

  @action
  setRallyPhase(RallyPhase value) {
    setWidgetVisibility(false);
    Timer(Seconds.get(0, milli: 500), () {
      phase = value;
      setWidgetVisibility(true);
    });
  }

  @action
  reset() {
    setWidgetVisibility(false);
    Timer(Seconds.get(1), () {
      currentlySelectedIndex = -1;
      phase = RallyPhase.initial;
      setGlowColor(GlowColor.transparent);
      setCancelButtonVisibility(true);
    });
  }

  backButtonTapReactor() => reaction((p0) => backButton.tapCount, (p0) {
        if (phase == RallyPhase.selection) {
          setRallyPhase(RallyPhase.initial);
        }
      });

  glowColorReactor() => reaction((p0) => glowColor, (p0) {
        if (p0 == GlowColor.inflectionRed) {
          setCancelButtonVisibility(false);
        }
      });

  @computed
  String get currentPartnerFirstName => currentlySelectedIndex == -1
      ? ''
      : currentPartnerFullName.split(' ').first;

  @computed
  String get currentPartnerFullName =>
      currentlySelectedIndex == -1 ? '' : collaborators[currentlySelectedIndex];
}
