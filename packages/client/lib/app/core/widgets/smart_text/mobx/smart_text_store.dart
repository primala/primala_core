// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'dart:ui';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/base_widget_store.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'smart_text_store.g.dart';

class SmartTextStore = _SmartTextStoreBase with _$SmartTextStore;

abstract class _SmartTextStoreBase extends BaseWidgetStore with Store {
  _SmartTextStoreBase() {
    setAltMovie(Seconds.get(500));
  }
  @action
  setAltMovie(Duration timerLength) {
    altMovie = SmartTextColorChangeMovie.getMovie(timerLength: timerLength);
  }

  @action
  setStaticAltMovie(Color color) {
    altMovie = StaticSmartTextColorMovie.getMovie(color);
  }

  @action
  setAltControl(Control newControl) => altControl = newControl;

  @observable
  MovieTween altMovie = MovieTween();

  @observable
  Control altControl = Control.stop;

  @observable
  ObservableList<RotatingTextData> messagesData = ObservableList.of([]);

  @observable
  int currentIndex = 0;

  @observable
  bool isPaused = false;

  @action
  setCurrentIndex(newIndex) => currentIndex = newIndex;

  @action
  setMessagesData(List<RotatingTextData> newList) {
    currentIndex = 0;
    messagesData = ObservableList.of(newList);
  }

  @action
  @override
  setWidgetVisibility(bool newVisibility) {
    if (!newVisibility) {
      setControl(Control.stop);
    }
    super.setWidgetVisibility(newVisibility);
  }

  @action
  reset() {
    currentIndex = 0;
    isPaused = false;
    setControl(Control.playFromStart);
    setControl(Control.stop);
    setWidgetVisibility(true);
  }

  @action
  startRotatingText({bool isResuming = false}) {
    movieStatus = MovieStatus.inProgress;
    if (isPaused) return;
    Timer(currentInitialFadeInDelay, () {
      if (isResuming) {
        setControl(Control.playReverse);
      } else {
        setControl(Control.play);
      }
    });
  }

  @action
  pause() {
    setControl(Control.stop);
  }

  @action
  resume() {
    startRotatingText(isResuming: true);
  }

  @action
  onOpacityTransitionComplete() {
    movieStatus = MovieStatus.finished;
    if (currentIndex < messagesData.length - 1) {
      if (control != Control.playReverse && !currentShouldPauseHere) {
        Timer(currentOnScreenTime, () {
          if (!isPaused) {
            setControl(Control.playReverse);
          }
        });
      } else if (control == Control.playReverse) {
        currentIndex++;
        Timer(Seconds.get(0, milli: 100), () {
          if (!isPaused) {
            setControl(Control.playFromStart);
          }
        });
      }
    }
  }

  @computed
  String get currentSubText => messagesData[currentIndex].subText;

  @computed
  String get currentMainText => messagesData[currentIndex].text;

  @computed
  bool get currentShouldPauseHere => messagesData[currentIndex].pauseHere;

  @computed
  double get currentMainTextFontSize => messagesData[currentIndex].mainFontSize;

  @computed
  double get currentSubTextFontSize => messagesData[currentIndex].subFontSize;

  @computed
  Duration get currentInitialFadeInDelay =>
      messagesData[currentIndex].initialFadeInDelay;

  @computed
  Duration get currentOnScreenTime => messagesData[currentIndex].onScreenTime;

  @computed
  bool get isDoneAnimating => movieStatus != MovieStatus.inProgress;
}
