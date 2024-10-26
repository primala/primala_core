import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/widgets/widgets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
import 'package:simple_animations/simple_animations.dart';
import 'rally_demo_painter.dart';

class RallyDemo extends HookWidget with RallyConstants {
  final List<SessionTags> allTheTags;
  RallyDemo(
    this.allTheTags, {
    super.key,
  });

  Widget getListItem(String text, double width) => Container(
        width: width * 0.32,
        margin: EdgeInsets.only(
          left: width * 0.1,
          bottom: width * 0.025,
        ),
        padding: EdgeInsets.symmetric(
          vertical: width * 0.005,
          horizontal: width * 0.03,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Chivo(
          text,
          fontSize: width * 0.04,
          fontWeight: FontWeight.w300,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final width = useFullScreenSize().width;
    final iconWidth = width * .12;

    return CustomAnimationBuilder(
      tween: DemoPhoneMovies.rally,
      duration: DemoPhoneMovies.rally.duration,
      control: Control.loop,
      builder: (context, value, child) {
        return MultiHitStack(
          children: [
            SizedBox(
              height: width,
              width: width,
              child: CustomPaint(
                painter: RallyDemoPainter(
                  glowColor: value.get('glowColor'),
                  glowStrokeWidth: value.get('glowStroke'),
                  restingTextOpacity: value.get('leftPhoneText'),
                  leftActiveTextOpacity: value.get('leftHeaderText'),
                  leftTintOpacity: value.get('collaboratorListOpacity'),
                  rightTintOpacity: value.get('rightTintOpacity'),
                  rightPhoneTextOpacity: value.get('rPhoneTextOpacity'),
                  containerSize: width,
                  allTheTags: allTheTags,
                  leftPhoneColorsList:
                      GetCurrentWaterAnimation.colors(value, prefix: 'l'),
                  leftPhoneStopsList:
                      GetCurrentWaterAnimation.stops(value, prefix: 'l'),
                  rightPhoneColorsList:
                      GetCurrentWaterAnimation.colors(value, prefix: 'r'),
                  rightPhoneStopsList:
                      GetCurrentWaterAnimation.stops(value, prefix: 'r'),
                  rightHeaderListeningTextOpacity:
                      value.get('rightHeaderListeningText'),
                  rightHeaderSpeakingTextOpacity:
                      value.get('rightHeaderSpeakingText'),
                ),
              ),
            ),
            SizedBox(
              height: width,
              width: width,
              child: CustomPaint(
                painter: OtherGlowPainter(
                  containerSize: width,
                  glowColor: value.get('rGlowColor'),
                  glowStrokeWidth: value.get('rGlowStroke'),
                ),
              ),
            ),
            Stack(
              children: [
                Opacity(
                  opacity: value.get('tapToRallyOpacity'),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: width * 0.35,
                      left: width * 0.16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/rally_button_blue.png',
                          width: iconWidth,
                          height: iconWidth,
                        ),
                        Jost(
                          'Tap to rally',
                          fontColor: navyBlue,
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w300,
                        )
                      ],
                    ),
                  ),
                ),
                Opacity(
                  opacity: value.get('collaboratorListOpacity'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.13,
                          top: width * 0.14,
                        ),
                        child: Chivo(
                          "Rally with:",
                          fontSize: width * 0.05,
                          shouldCenter: true,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(height: 15),
                      getListItem('Rick Astley', width),
                      getListItem('Bob Ross', width),
                    ],
                  ),
                ),
                Opacity(
                  opacity: value.get('activeInitiatorOpacity'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: width * 0.15,
                          top: width * 0.24,
                          left: width * 0.1,
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/rally_button_blue.png',
                              width: iconWidth,
                              height: iconWidth,
                            ),
                            Jost(
                              'Rallying with Rick',
                              fontColor: navyBlue,
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w300,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: width * 0.15,
                          left: width * 0.163,
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/rally_button_red.png',
                              width: iconWidth,
                              height: iconWidth,
                            ),
                            Jost(
                              'Stop Rally',
                              fontColor: redGrad.first,
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w300,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Opacity(
                  opacity: value.get('activeRecipientOpacity'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: width * 0.15,
                          top: width * 0.35,
                          left: width * 0.6,
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/rally_button_blue.png',
                              width: iconWidth,
                              height: iconWidth,
                            ),
                            Jost(
                              'Rallying with Paul',
                              fontColor: navyBlue,
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w300,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
