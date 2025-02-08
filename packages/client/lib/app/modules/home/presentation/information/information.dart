import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
export 'information_coordinator.dart';

class InformationScreen extends HookWidget {
  final InformationCoordinator coordinator;

  const InformationScreen({
    super.key,
    required this.coordinator,
  });

  Widget _buildFeatureItem({
    required String imagePath,
    required String title,
    required String description,
    required Size screenSize,
    bool hasBorder = false,
    bool hasPadding = false,
    double imageSize = 50,
    EdgeInsets padding = const EdgeInsets.only(left: 20),
  }) {
    return HookBuilder(
      builder: (context) {
        final scaledTextSize = useScaledSize(
          baseValue: .02,
          screenSize: screenSize,
          bumpPerHundredth: 0.0001,
        );

        final scaledGapSize = useScaledSize(
          baseValue: .02,
          screenSize: screenSize,
          bumpPerHundredth: 0.0001,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: padding,
              child: hasBorder
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: hasBorder ? 1 : 1,
                        ),
                        shape: BoxShape.circle,
                      ),
                      padding: hasPadding
                          ? const EdgeInsets.all(5)
                          : EdgeInsets.zero,
                      child: Image.asset(
                        imagePath,
                        color: Colors.black,
                        height: imageSize,
                        width: imageSize,
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      color: Colors.black,
                      height: imageSize,
                      width: imageSize,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Jost(
                title,
                fontColor: Colors.black,
                fontSize: scaledTextSize * 1.2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 52, right: 20),
              child: Jost(
                description,
                softWrap: true,
                fontSize: scaledTextSize * .9,
              ),
            ),
            SizedBox(height: scaledGapSize),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
    }, []);

    final screenSize = useFullScreenSize();
    final headerSpacing = useScaledSize(
      baseValue: .03,
      screenSize: screenSize,
      bumpPerHundredth: -.0003,
    );

    return Observer(
      builder: (context) => CarouselScaffold(
        initialPosition: 0,
        showWidgets: coordinator.showWidgets,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderRow(title: 'Session Information'),
          SizedBox(height: headerSpacing),
          _buildFeatureItem(
            imagePath: 'assets/power_up/cook_button.png',
            title: 'Cook',
            description:
                'When someone is saying something useful, you can give them more time to speak',
            screenSize: screenSize,
          ),
          _buildFeatureItem(
            imagePath: 'assets/power_up/rally_button_blue.png',
            title: 'Rally',
            description:
                'When you want to ask a quick question, or get a quick response, you can start a rally',
            screenSize: screenSize,
            hasBorder: true,
            hasPadding: false,
          ),
          _buildFeatureItem(
            imagePath: 'assets/session/pencil_icon.png',
            title: 'Docs',
            description:
                'With a limit of 2,000 characters per document, you can create and condense your thoughts as a group',
            screenSize: screenSize,
            hasBorder: true,
            hasPadding: true,
            imageSize: 35,
          ),
        ],
      ),
    );
  }
}
