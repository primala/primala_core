import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'purpose_banner.dart';
export 'purpose_banner.dart';
export 'purpose_banner_store.dart';

class PurposeBanner extends HookWidget {
  final PurposeBannerStore store;
  const PurposeBanner({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    store.constructor(
      context,
      useAnimationController(
        duration: Seconds.get(1),
        reverseDuration: Seconds.get(1),
      ),
    );
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
                    // print('Pressed');
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
                    // height: height * 0.18,
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: height * .02,
                            left: height * .03,
                            bottom: height * .02,
                          ),
                          child: Text(
                            store.purpose,
                            style: GoogleFonts.jost(
                              color: Colors.white,
                              fontSize: height * .025,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 2, right: 8.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18,
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
        NokhteBlur(
          store: store.nokhteBlur,
        ),
      ],
    );
  }
}
