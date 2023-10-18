// ignore_for_file: must_be_immutable, library_private_types_in_public_api
// * Mobx Import
import 'package:mobx/mobx.dart';
// * Equatable Import
import 'package:equatable/equatable.dart';
import 'package:primala/app/core/types/types.dart';
import 'package:primala/app/core/widgets/conveyer_belt_text/stack/constants/movies/movies.dart';
import 'package:primala/app/core/widgets/conveyer_belt_text/stack/constants/types/conveyer_movie_modes.dart';
import 'package:primala/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
// * Mobx Codegen Inclusion
part 'conveyer_belt_text_store.g.dart';

class ConveyerBeltTextStore = _ConveyerBeltTextStoreBase
    with _$ConveyerBeltTextStore;

abstract class _ConveyerBeltTextStoreBase extends Equatable with Store {
  @observable
  bool showWidget = false;

  DateOrTime currentFocus = DateOrTime.date;

  @observable
  MovieTween movie = DefaultLayoutMovie.movie;

  @observable
  ConveyerMovieModes movieMode = ConveyerMovieModes.idleInRange;

  @observable
  MovieStatus movieStatus = MovieStatus.idle;

  @observable
  Control control = Control.stop;

  @observable
  List<String> uiArray = [];

  @observable
  ReturnDateOrTimeEntity returnEntity =
      const ReturnDateOrTimeEntity(dateOrTimeList: [], activeSelectionIndex: 0);

  @computed
  int get leftMostIndex => currentlySelectedIndex - 2;

  @computed
  int get leftIndex => currentlySelectedIndex - 1;

  @computed
  int get rightIndex => currentlySelectedIndex + 1;

  @computed
  int get rightMostIndex => currentlySelectedIndex + 2;

  @computed
  int get focusListCardinalLength => theFocusedList.length - 1;

  @computed
  List<GeneralDateTimeReturnType> get theFocusedList =>
      currentFocus == DateOrTime.date ? dates : times;

  @observable
  int currentlySelectedIndex = 0;

  List<GeneralDateTimeReturnType> dates = [];

  List<GeneralDateTimeReturnType> times = [];

  final ReturnDateOrTimeArray logic;

  _ConveyerBeltTextStoreBase({
    required this.logic,
    required DateOrTime dateOrTimeParam,
  }) {
    setDatesArray();
    setUIArray(dates);
  }

  @action
  void setWidgetVisibility(bool newVisiblity) => showWidget = newVisiblity;

  @action
  setCurrentlySelectedIndex(int index) {
    currentlySelectedIndex = index;
  }

  @action
  toggleListFocus() => currentFocus == DateOrTime.date
      ? currentFocus = DateOrTime.time
      : DateOrTime.date;

  @action
  setDatesArray() {
    returnEntity = logic(
      ReturnDateOrTimeArrayParams(
        dateOrTime: DateOrTime.date,
        currentTime: DateTime.now(),
      ),
    );
    dates = returnEntity.dateOrTimeList;
    setCurrentlySelectedIndex(returnEntity.activeSelectionIndex);
  }

  @action
  setTimesArray() {
    returnEntity = logic(
      ReturnDateOrTimeArrayParams(
        dateOrTime: DateOrTime.time,
        currentTime: DateTime.now(),
      ),
    );
    toggleListFocus();
    times = returnEntity.dateOrTimeList;
    setCurrentlySelectedIndex(returnEntity.activeSelectionIndex);
  }

  @action
  setUIArray(List<GeneralDateTimeReturnType> inputArr) {
    // left
    final leftMostVal =
        leftMostIndex.isNegative ? "" : theFocusedList[leftMostIndex].formatted;
    final leftVal =
        leftIndex.isNegative ? "" : theFocusedList[leftIndex].formatted;
    // center
    final centerVal = focusListCardinalLength == 0
        ? ""
        : theFocusedList[currentlySelectedIndex].formatted;
    // right
    final rightVal = rightIndex > focusListCardinalLength
        ? ""
        : theFocusedList[rightIndex].formatted;
    final rightMostVal = rightMostIndex > focusListCardinalLength
        ? ""
        : theFocusedList[rightMostIndex].formatted;

    uiArray = [leftMostVal, leftVal, centerVal, rightVal, rightMostVal];
  }

  @action
  initForwardMovie() {
    // print("is forward running?? $movieStatus");
    if (movieStatus == MovieStatus.inProgress) return;
    if (currentlySelectedIndex == focusListCardinalLength) {
      movie = AtMinOrMax.getMovie(atMin: false); // at max
      control = Control.play;
      movieStatus = MovieStatus.inProgress;
    } else {
      movie = ForwardsOrBackwards.getMovie(isForward: true); // at min
      movieMode = ConveyerMovieModes.forward;
      control = Control.play;
      movieStatus = MovieStatus.inProgress;
    }
  }

  @action
  initBackwardMovie() {
    if (movieStatus == MovieStatus.inProgress) return;
    if (currentlySelectedIndex == 0) {
      movie = AtMinOrMax.getMovie(atMin: true);
      control = Control.play;
      movieStatus = MovieStatus.inProgress;
    } else {
      movie = ForwardsOrBackwards.getMovie(isForward: false); // at min
      movieMode = ConveyerMovieModes.backwards;
      control = Control.play;
      movieStatus = MovieStatus.inProgress;
    }
  }

  @action
  onCompletedMovie() {
    switch (movieMode) {
      case ConveyerMovieModes.forward:
        movie = DefaultLayoutMovie.movie;
        setCurrentlySelectedIndex(currentlySelectedIndex + 1);
        currentFocus == DateOrTime.date ? setUIArray(dates) : setUIArray(times);
        movieMode = currentlySelectedIndex == focusListCardinalLength
            ? ConveyerMovieModes.idleMax
            : ConveyerMovieModes.idleInRange;
        movieStatus = MovieStatus.idle;
      case ConveyerMovieModes.backwards:
        movie = DefaultLayoutMovie.movie;
        setCurrentlySelectedIndex(currentlySelectedIndex - 1);
        currentFocus == DateOrTime.date ? setUIArray(dates) : setUIArray(times);
        movieMode = currentlySelectedIndex == 0
            ? ConveyerMovieModes.idleMin
            : ConveyerMovieModes.idleInRange;
        movieStatus = MovieStatus.idle;
      default:
        movieStatus = MovieStatus.idle;
        break;
    }
  }

  @override
  List<Object> get props => [];
}
