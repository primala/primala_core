import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';

void main() {
  late NokhteBlurStore testStore;

  setUp(() => testStore = NokhteBlurStore());

  group("actions", () {
    test("init", () {
      testStore.init();
      expect(testStore.control, Control.play);
    });
    test('reverse', () {
      testStore.reverse();
      expect(testStore.control, Control.playReverse);
    });
  });
}
