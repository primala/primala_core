// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/constants/text_field_validators.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/auth/auth.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:nokhte_backend/types/types.dart';
import 'package:simple_animations/simple_animations.dart';
part 'account_settings_coordinator.g.dart';

class AccountSettingsCoordinator = _AccountSettingsCoordinatorBase
    with _$AccountSettingsCoordinator;

abstract class _AccountSettingsCoordinatorBase
    with
        Store,
        BaseMobxLogic,
        BaseWidgetsCoordinator,
        AnimatedScaffoldMovie,
        BaseCoordinator,
        TextFieldValidators,
        Reactions {
  final UserContract contract;
  final AnimatedScaffoldStore animatedScaffold;
  @override
  final CaptureScreen captureScreen;

  _AccountSettingsCoordinatorBase({
    required this.animatedScaffold,
    required this.contract,
    required this.captureScreen,
  }) {
    initBaseWidgetsCoordinatorActions();
    initBaseLogicActions();
  }

  constructor() async {
    animatedScaffold.setMovie(getMovie(
      NokhteColors.eggshell,
      NokhteColors.black,
    ));
    disposers.add(animatedScaffoldReactor());
    await getUserInformation();
    await checkIfCanDeleteAccount();
    await captureScreen(GroupsConstants.accountSettings);
  }

  @observable
  UserEntity user = UserEntity.initial();

  @observable
  bool canDeleteAccount = false;

  @observable
  String nameErrorText = '';

  @observable
  String nameInput = '';

  @action
  getUserInformation() async {
    final res = await contract.getUserInformation();
    res.fold(
      (failure) => errorUpdater(failure),
      (success) {
        user = success;
        nameInput = user.fullName;
        fadeInWidgets();
      },
    );
  }

  @action
  checkIfCanDeleteAccount() async {
    final res = await contract.checkIfCanDeleteAccount();
    res.fold(
      (failure) => errorUpdater(failure),
      (success) => canDeleteAccount = success,
    );
  }

  @action
  onDelete() async {
    final res = await contract.deleteAccount();
    res.fold(
      (failure) => errorUpdater(failure),
      (success) {
        setShowWidgets(false);
        animatedScaffold.setControl(Control.playFromStart);
      },
    );
  }

  @action
  onNameChanged(String value) {
    nameErrorText = validateFullName(value);
    nameInput = value;
  }

  @action
  onNameSubmit(String value) async {
    if (nameHasError || value.isEmpty) return;
    final res = await contract.updateFullName(value);
    res.fold(
      (failure) => errorUpdater(failure),
      (success) async => await getUserInformation(),
    );
  }

  @action
  onGradientChanged(ProfileGradient gradient) async {
    final res = await contract.updateUserProfileGradient(gradient);
    res.fold(
      (failure) => errorUpdater(failure),
      (success) async {
        await getUserInformation();
        Modular.to.pop();
      },
    );
  }

  @action
  onGoBack() => Modular.to.pop();

  animatedScaffoldReactor() =>
      reaction((p0) => animatedScaffold.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          Modular.to.navigate(AuthConstants.greeter);
        }
      });

  @computed
  bool get nameHasError => nameErrorText.isNotEmpty;
}
