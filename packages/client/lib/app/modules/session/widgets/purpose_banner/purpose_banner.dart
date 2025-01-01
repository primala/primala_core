import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'purpose_banner.dart';
export 'widgets/widgets.dart';
export 'purpose_banner_store.dart';

class PurposeBanner extends HookWidget {
  final PurposeBannerStore store;
  const PurposeBanner({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      store.constructor(
        context,
        // useAnimationController(
        //   duration: Seconds.get(1),
        //   reverseDuration: Seconds.get(1),
        // ),
      );
      return null;
    }, []);
    final height = useFullScreenSize().height;
    final width = useFullScreenSize().width;

    return MultiHitStack(
      children: [
        Observer(builder: (context) {
          return AnimatedOpacity(
            opacity: useWidgetOpacity(store.showWidget),
            duration: Seconds.get(0, milli: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    print('tap ');
                    store.onTap();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(19),
                        topRight: Radius.circular(19),
                      ),
                      color: Colors.black.withOpacity(.2),
                    ),
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Center(
                            child: Container(
                              height: 4,
                              width: width * 0.15,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        // // Content
                        Padding(
                          padding: EdgeInsets.only(
                            left: height * .03,
                            right: height * .03,
                            top: height * .01,
                            bottom: height * .04,
                          ),
                          child: Text(
                            store.currentFocus,
                            style: GoogleFonts.jost(
                              color: Colors.white,
                              fontSize: height * .025,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
