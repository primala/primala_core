// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:ui';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'preset_cards_store.g.dart';

class PresetCardsStore = _PresetCardsStoreBase with _$PresetCardsStore;

abstract class _PresetCardsStoreBase extends BaseWidgetStore with Store {
  @observable
  ObservableList<Control> controls = ObservableList();

  @observable
  ObservableList<MovieTween> movies = ObservableList();

  @observable
  ObservableList<bool> isEnabled = ObservableList();

  @observable
  ObservableList<MovieStatus> movieStatuses = ObservableList();

  @observable
  ObservableList<Color> selectedPresetColors = ObservableList.of([]);

  @observable
  CompanyPresetsEntity companyPresetsEntity = CompanyPresetsEntity.initial();

  @observable
  String preferredPresetUID = "";

  @action
  setPreferredPresetUID(String uid) => preferredPresetUID = uid;

  @action
  setPresets(CompanyPresetsEntity presetsEntity) {
    companyPresetsEntity = presetsEntity;
  }

  @action
  showAllCondensedPresets() {
    fadeEverythingIn();
    setWidgetVisibility(true);
  }

  @action
  activateSelectedPreset() {
    if (preferredPresetUID.isNotEmpty) {
      enableAllTouchFeedback();
      setCurrentHeldIndex(preferredPresetIndex);
      selectPreset(preferredPresetIndex);
    }
  }

  @action
  selectPreset(int index) {
    initSelectionInProgress(index);
  }

  @action
  setSelectedPresetColors(List<Color> colors) =>
      selectedPresetColors = ObservableList.of(colors);

  @observable
  ObservableList<CondensedPresetCardMovieModes> movieModes = ObservableList();

  @observable
  int currentTappedIndex = -1;

  @observable
  ObservableList<int> heldIndices = ObservableList();

  @action
  onTap(int i) {
    tapCount++;
    if (isEnabled[i]) {
      currentTappedIndex = i;
    }
  }

  @action
  initWindDown(int i) {
    movies[i] = PresetCardSelectionMovies.getWindDown(selectedPresetColors);
    controls[i] = Control.play;
    movieStatuses[i] = MovieStatus.idle;
    movieModes[i] = CondensedPresetCardMovieModes.selectionWindDown;
  }

  @observable
  int pastHeldIndex = -1;

  @observable
  int currentHeldIndex = -1;

  @action
  setCurrentHeldIndex(int i, {bool override = false}) {
    if (isEnabled[i] || override) {
      pastHeldIndex = currentHeldIndex;
      currentHeldIndex = i;
    }
  }

  @action
  initSelectionInProgress(int index) {
    Control pastHeldIndexControl = Control.stop;
    if (pastHeldIndex != -1) {
      pastHeldIndexControl = controls[pastHeldIndex];
    }
    controls = ObservableList.of(List.generate(length, (i) {
      if (i == index) {
        return Control.playFromStart;
      } else if (i == pastHeldIndex && pastHeldIndex != -1) {
        return pastHeldIndexControl;
      } else {
        return Control.stop;
      }
    }));
    movieModes[index] = CondensedPresetCardMovieModes.selectionInProgress;
    movies[index] = PresetCardSelectionMovies.inProgress;
    // resetMovieStatuses();
    movieStatuses[index] = MovieStatus.idle;
  }

  @action
  initSelectionMovie(int index) {
    resetMovieStatuses();
    movieModes[index] = CondensedPresetCardMovieModes.activeSelection;
    movieStatuses[index] = MovieStatus.idle;
    controls = ObservableList.of(List.generate(length, (i) {
      if (i == index) {
        return Control.loop;
      } else {
        return Control.stop;
      }
    }));
    movies[index] = PresetCardSelectionMovies.active;
  }

  @action
  fadeEverythingIn() {
    resetMovieStatuses();
    controls = ObservableList.of(List.filled(length, Control.playFromStart));
    movieModes = ObservableList.of(
        List.filled(length, CondensedPresetCardMovieModes.fadeIn));
    movies =
        ObservableList.of(List.filled(length, FadePresetCardMovies.fadeIn));
    isEnabled = ObservableList.of(List.filled(length, false));
  }

  @action
  disableAllTouchFeedback() =>
      isEnabled = ObservableList.of(List.filled(length, false));

  @action
  disableAllTouchFeedbackExcept(int index) =>
      isEnabled = ObservableList.of(List.generate(length, (i) {
        if (i == index) {
          return true;
        } else {
          return false;
        }
      }));

  @action
  enableAllTouchFeedback() =>
      isEnabled = ObservableList.of(List.filled(length, true));

  @action
  onAnimationCompleted(int i) => movieStatuses[i] = MovieStatus.finished;

  @action
  resetMovieStatuses() => movieStatuses =
      ObservableList.of(List.filled(length, MovieStatus.inProgress));

  // @computed
  // int get currentHeldIndex => heldIndices.isEmpty ? -1 : heldIndices[0];

  // @computed
  // int get pastHeldIndex =>
  //     heldIndices.length.isLessThan(2) ? -1 : heldIndices[1];

  @computed
  List<String> get uids => companyPresetsEntity.uids;

  @computed
  int get length => companyPresetsEntity.uids.length;

  @computed
  PresetArticleEntity get currentlyTappedArticle =>
      companyPresetsEntity.articles[currentTappedIndex];

  @computed
  List<List<SessionTags>> get tags => companyPresetsEntity.tags;

  @computed
  List<String> get names {
    final List<String> temp = [];
    for (var article in companyPresetsEntity.articles) {
      temp.add(article.title);
    }
    return temp;
  }

  @computed
  List<String> get taglines {
    final List<String> temp = [];
    for (var article in companyPresetsEntity.articles) {
      temp.add(article.tagline);
    }
    return temp;
  }

  @computed
  List<PresetTypes> get presetTypes => companyPresetsEntity.presets;

  @computed
  String get currentlySelectedSessionUID =>
      currentHeldIndex == -1 ? '' : uids[currentHeldIndex];

  @computed
  bool get currentArticleHasOptions =>
      currentlyTappedArticle.options.isNotEmpty;

  @computed
  int get preferredPresetIndex => uids.isEmpty || preferredPresetUID.isEmpty
      ? -1
      : uids.indexOf(preferredPresetUID);
}
