import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
export 'canvas/canvas.dart';

typedef ToggleCallback = void Function({
  required SessionTags pastTag,
  required SessionTags newTag,
})?;

class ArticleToggle extends HookWidget {
  final String label;
  final List<String> glyphs;
  final List<SessionTags> articleSections;
  final SessionTags leftToggle;
  final SessionTags rightToggle;

  final ToggleCallback onToggle;

  const ArticleToggle({
    super.key,
    required this.label,
    required this.leftToggle,
    required this.rightToggle,
    required this.articleSections,
    this.glyphs = const [],
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final toggleHeight = useFullScreenSize().height * 0.08;

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    final toggleValue = useState(0.0);
    final animation = useAnimation(controller);

    void toggle() {
      if (toggleValue.value == 0) {
        controller.forward();
        toggleValue.value = 1;
        onToggle?.call(
          pastTag: leftToggle,
          newTag: rightToggle,
        );
      } else {
        controller.reverse();
        toggleValue.value = 0;
        onToggle?.call(
          pastTag: rightToggle,
          newTag: leftToggle,
        );
      }
    }

    useEffect(() {
      if (articleSections.contains(rightToggle)) {
        controller.fling(
          velocity: 2,
        );
        toggleValue.value = 1;
      }
      return null;
    }, []);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Jost(
            label,
            fontSize: 20,
          ),
        ),
        GestureDetector(
          onTap: toggle,
          child: SizedBox(
            height: toggleHeight / 2,
            width: toggleHeight,
            child: CustomPaint(
              painter: glyphs.isNotEmpty
                  ? GlyphTogglePainter(
                      toggleVal: animation,
                      leftGlyph: glyphs[0],
                      rightGlyph: glyphs[1],
                    )
                  : VanillaTogglePainter(
                      toggleVal: animation,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
