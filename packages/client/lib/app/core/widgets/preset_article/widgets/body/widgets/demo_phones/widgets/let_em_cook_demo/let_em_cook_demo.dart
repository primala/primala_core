import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/widgets/widgets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
import 'package:simple_animations/simple_animations.dart';
import 'let_em_cook_demo_painter.dart';
import 'movie.dart';

class LetEmCookDemo extends HookWidget {
  final List<SessionTags> allTheTags;
  const LetEmCookDemo(
    this.allTheTags, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = useFullScreenSize().width;
    final iconWidth = width * .12;

    return CustomAnimationBuilder(
      tween: letEmCook,
      duration: letEmCook.duration,
      control: Control.loop,
      builder: (context, value, child) {
        return MultiHitStack(
          children: [
            SizedBox(
              height: width,
              width: width,
              child: CustomPaint(
                painter: LetEmCookDemoPainter(
                  glowColor: value.get('glowColor'),
                  glowStrokeWidth: value.get('glowStroke'),
                  restingTextOpacity: value.get('p1Text'),
                  activeTextOpacity: value.get('p2Text'),
                  allTheTags: allTheTags,
                  containerSize: width,
                  leftPhoneColorsList:
                      GetCurrentWaterAnimation.colors(value, prefix: 'l'),
                  leftPhoneStopsList:
                      GetCurrentWaterAnimation.stops(value, prefix: 'l'),
                  rightPhoneColorsList:
                      GetCurrentWaterAnimation.colors(value, prefix: 'r'),
                  rightPhoneStopsList:
                      GetCurrentWaterAnimation.stops(value, prefix: 'r'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: width * 0.35,
                left: width * 0.47,
              ),
              child: Stack(
                children: [
                  Opacity(
                    opacity: value.get('cookOpacity'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                            height: iconWidth,
                            width: iconWidth,
                            child: Image.asset(
                              'assets/cook_button.png',
                              width: iconWidth,
                              height: iconWidth,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Jost(
                            "Let 'em cook",
                            fontSize: width * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          height: iconWidth,
                          width: iconWidth,
                          child: CustomPaint(
                            painter: CheckmarkPainter(
                              l1Progress: value.get('l1'),
                              l2Progress: value.get('l2'),
                              opacity: value.get('checkMarkCapacity'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: NokhteGradientText(
                          textScaleFactor: 1,
                          store: NokhteGradientTextStore(),
                          content: 'Sent',
                          gradient: LetEmCookConstants.greenGrad(
                            value.get('checkMarkCapacity'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
