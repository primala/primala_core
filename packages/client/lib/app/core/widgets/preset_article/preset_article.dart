import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
export 'widgets/widgets.dart';
export 'movies/movies.dart';
export 'mobx/preset_article_store.dart';
export 'types/types.dart';

class PresetArticle extends HookWidget {
  final PresetArticleStore store;
  final bool showBottomCard;
  const PresetArticle({
    super.key,
    required this.store,
    this.showBottomCard = false,
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
    return Observer(builder: (context) {
      return MultiHitStack(
        children: [
          showBottomCard
              ? AnimatedOpacity(
                  opacity: useWidgetOpacity(store.showPreview),
                  duration: Seconds.get(1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          store.onTap();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19),
                            color: Colors.white.withOpacity(.2),
                          ),
                          height: height * 0.18,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: height * .02, left: height * .03),
                                    child: Text(
                                      store.article.title,
                                      style: GoogleFonts.jost(
                                        color: Colors.white,
                                        fontSize: height * .03,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 2, right: 8.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TagLine(
                                  store.article.tagline,
                                  useExpandedPadding: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          NokhteBlur(
            store: store.nokhteBlur,
          ),
        ],
      );
    });
  }
}
