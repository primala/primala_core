// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'nokhte_blur_store.g.dart';

class NokhteBlurStore = _NokhteBlurStoreBase with _$NokhteBlurStore;

abstract class _NokhteBlurStoreBase extends BaseWidgetStore with Store {
  _NokhteBlurStoreBase() {
    setMovie(BlurMovie.getMovie(blurValue: 10.0));
  }

  @observable
  bool hasBlurredIn = false;

  @action
  init({
    double blurValue = 10.0,
    Duration end = const Duration(seconds: 1),
  }) {
    hasBlurredIn = true;
    setMovie(
      BlurMovie.getMovie(
        blurValue: blurValue,
        end: end,
      ),
    );
    setMovieStatus(MovieStatus.inProgress);
    setControl(Control.play);
  }

  @action
  reset() {
    setControl(Control.playFromStart);
    setControl(Control.stop);
  }

  @action
  reverse() {
    hasBlurredIn = false;
    setMovieStatus(MovieStatus.inProgress);
    setControl(Control.playReverse);
  }
}
