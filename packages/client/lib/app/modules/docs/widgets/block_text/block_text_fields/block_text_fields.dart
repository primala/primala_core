import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:simple_animations/simple_animations.dart';
export 'block_text_fields_store.dart';
export 'movies/movies.dart';
export 'block_text_field_mode.dart';

class BlockTextFields extends HookWidget {
  final BlockTextFieldsStore store;
  const BlockTextFields({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      store.constructor();
      return () async => await store.dispose();
    }, []);

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    Widget buildBlockIcon(ContentBlockType type, double position) {
      return Positioned(
        bottom: position,
        child: GestureDetector(
          onTap: () => store.onTap(type),
          child: Image.asset(
            BlockTextConstants.getAssetPath(type),
            width: 37,
            height: 37,
          ),
        ),
      );
    }

    return Observer(builder: (context) {
      // final movieIsInProgress = store.movieStatus == MovieStatus.inProgress;
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(1),
        child: FullScreen(
          child: MultiHitStack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: Blur(
                  blur: 10,
                  blurColor: Colors.black,
                  colorOpacity: 0.2,
                  child: AnimatedContainer(
                    duration: store.iconMovieStatus == MovieStatus.inProgress
                        ? Seconds.get(0, milli: 300)
                        : Seconds.get(0),
                    height: (bottomPadding < 100 ? 0 : -35) +
                        (store.isExpanded ? 190 : 0) +
                        store.textFieldHeight,
                    color: Colors.transparent,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: MultiHitStack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    NokhteCustomAnimationBuilder(
                        tween: store.iconMovie,
                        duration: store.iconMovie.duration,
                        control: store.iconControl,
                        onCompleted: () {
                          store.setIconMovieStatus(MovieStatus.finished);
                          store.setIconControl(Control.stop);
                        },
                        builder: (context, value, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: store.isExpanded
                                    ? Seconds.get(0, milli: 300)
                                    : Seconds.get(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                alignment: Alignment.bottomLeft,
                                width: 35,
                                margin: EdgeInsets.only(
                                    left: 10.0,
                                    bottom: bottomPadding < 100 ? 50 : 20),
                                height: store.isExpanded ? 233 : 37,
                                child: MultiHitStack(
                                  clipBehavior: Clip.none,
                                  children: store.blockIcons
                                      .map(
                                        (entry) => buildBlockIcon(
                                          entry,
                                          value.get(
                                            '${entry.name}_bottom_position',
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          );
                        }),
                    NokhteCustomAnimationBuilder(
                        tween: store.movie,
                        duration: store.movie.duration,
                        control: store.control,
                        builder: (context, value, child) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 60.0,
                                bottom: bottomPadding < 100 ? 50 : 20,
                                right: 20),
                            child: Container(
                              key: store.textFieldKey,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19),
                                border: GradientBoxBorder(
                                  gradient: LinearGradient(
                                    colors: [value.get('c1'), value.get('c2')],
                                    stops: [value.get('s1'), value.get('s2')],
                                  ),
                                ),
                              ),
                              child: MultiHitStack(
                                children: [
                                  TextFormField(
                                    controller: store.controller,
                                    focusNode: store.focusNode,
                                    scrollPadding: EdgeInsets.zero,
                                    keyboardType: TextInputType.multiline,
                                    onChanged: store.onChange,
                                    maxLines: null,
                                    // enabled: bottomPadding == 0
                                    //     //&& movieIsInProgress
                                    //     ? false
                                    //     : true,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      hintText: 'your ${store.blockType.name}',
                                      hintStyle: GoogleFonts.jost(
                                        color: const Color.fromARGB(
                                            192, 255, 255, 255),
                                        fontSize: 14,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                        right: 30,
                                        left: 20,
                                        top: 7,
                                        bottom: 7,
                                      ),
                                    ),
                                    cursorColor: Colors.white,
                                    style: GoogleFonts.jost(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3.0, right: 3),
                                      child: GestureDetector(
                                        onTap: () {
                                          store.onSubmit();
                                          // store.textFieldHeight = 97;
                                        },
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                value.get('ic1'),
                                                value.get('ic2')
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              stops: [
                                                value.get('s1'),
                                                value.get('s2')
                                              ],
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.arrow_upward_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
