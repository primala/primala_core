import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:simple_animations/simple_animations.dart';
export 'block_text_fields_store.dart';
export 'movies/movies.dart';
export 'block_text_field_mode.dart';

class BlockTextFields extends HookWidget with DialogueUtils {
  final BlockTextFieldsStore store;
  final Color fontColor;
  final Color baseColor;
  const BlockTextFields({
    super.key,
    required this.store,
    this.fontColor = Colors.black,
    this.baseColor = NokhteColors.eggshell,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    double bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    double size = bottomPadding > 100
        ? 0
        : useScaledSize(
            baseValue: .03,
            bumpPerHundredth: -0.001,
            screenSize: screenSize,
          );
    final iconPadding = bottomPadding > 100
        ? 20.0
        : useScaledSize(
            baseValue: .055,
            bumpPerHundredth: -.0006,
            screenSize: screenSize,
          );

    useEffect(() {
      store.constructor();
      store.setExtraHeight(size);
      return () async => await store.dispose();
    }, []);
    return Observer(builder: (context) {
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(1),
        child: FullScreen(
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: MultiHitStack(
              alignment: Alignment.bottomCenter,
              children: [
                GestureDetector(
                  onTap: store.isFocused
                      ? store.currentlySelectedParentId != -1
                          ? () => showDeleteConfirmationDialog(
                                context: context,
                                onConfirm: store.onParentDeselected,
                                title: 'Discard Input',
                                content:
                                    'Are you sure you want to discard your input?',
                              )
                          : () => showDeleteConfirmationDialog(
                                context: context,
                                onConfirm: store.reset,
                                title: 'Discard Input',
                                content:
                                    'Are you sure you want to discard your input?',
                              )
                      // : () => store.reset()
                      : null,
                  child: NokhteBlur(
                    store: store.blur,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedOpacity(
                      opacity: useWidgetOpacity(
                        store.currentlySelectedParentId != -1,
                      ),
                      duration: const Duration(seconds: 0, milliseconds: 300),
                      child: Container(
                        // height: 40,
                        // height: 500,
                        alignment: Alignment.bottomLeft,
                        margin: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 10,
                        ),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: GradientBoxBorder(
                            gradient: BlockTextConstants.getGradient(
                              store.currentlySelectedBlock.type,
                            ),
                          ),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: -2,
                              left: 0,
                              child: Image.asset(
                                BlockTextConstants.getAssetPath(
                                    store.currentlySelectedBlock.type),
                                width: 25,
                                height: 25,
                              ),
                            ),
                            Jost(
                              '${BlockTextConstants.whiteSpace}${store.currentlySelectedBlock.content}',
                              fontSize: 16,
                              softWrap: true,
                              fontColor: fontColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedContainer(
                        duration: Seconds.get(0),
                        child: MultiHitStack(
                          children: [
                            _buildTextFieldContainer(bottomPadding),
                          ],
                        )),
                    AnimatedContainer(
                      duration: Seconds.get(0, milli: 200),
                      height: size,
                      color: baseColor,
                    )
                  ],
                ),
                _buildIconColumn(iconPadding),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildIconColumn(double bottomPadding) {
    return NokhteCustomAnimationBuilder(
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Main container with icons
                AnimatedContainer(
                  duration: store.isExpanded
                      ? Seconds.get(0, milli: 300)
                      : Seconds.get(0, milli: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: baseColor,
                  ),
                  alignment: Alignment.bottomLeft,
                  width: 35,
                  margin: EdgeInsets.only(
                    left: 10.0,
                    bottom: bottomPadding,
                    top: 20,
                  ),
                  height: store.isExpanded ? 233 : 37,
                  child: MultiHitStack(
                    clipBehavior: Clip.none,
                    children: store.blockIcons
                        .map(
                          (entry) => _buildBlockIcon(
                            entry,
                            value.get('${entry.name}_bottom_position'),
                          ),
                        )
                        .toList(),
                  ),
                ),
                // Up arrow indicator that shows when expanded
                Positioned(
                  top: 0,
                  left: 17.5,
                  child: AnimatedOpacity(
                    opacity: (store.isExpanded ||
                            store.iconMovieStatus == MovieStatus.inProgress)
                        ? 0.0
                        : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: Icon(
                          CupertinoIcons.chevron_up,
                          color: fontColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBlockIcon(ContentBlockType type, double position) {
    final bool showWidget = ((store.isExpanded) ||
            (!store.isExpanded &&
                store.iconMovieStatus != MovieStatus.finished)) ||
        type == store.blockIcons.last;
    return Positioned(
      bottom: position,
      child: Visibility(
        visible: showWidget,
        child: GestureDetector(
          onTap: () => store.onTap(type),
          child: Image.asset(
            BlockTextConstants.getAssetPath(type),
            width: type == store.blockIcons.last ? 37 : 36,
            height: type == store.blockIcons.last ? 37 : 36,
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldContainer(double bottomPadding) {
    return NokhteCustomAnimationBuilder(
      tween: store.movie,
      duration: store.movie.duration,
      control: store.control,
      builder: (context, value, child) {
        return Container(
          color: baseColor,
          child: MultiHitStack(
            children: [
              _buildBlurredBackground(value, bottomPadding),
              _buildForegroundTextField(value, bottomPadding),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBlurredBackground(dynamic value, double bottomPadding) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 60.0,
        bottom: 20,
        right: 20,
        top: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: _buildGradientBorder(value),
        ),
        child: Blur(
          blur: 10,
          blurColor: Colors.black,
          colorOpacity: .6,
          borderRadius: BorderRadius.circular(17),
          child: _buildTextField(
            onChange: store.onChange,
            textColor: const Color.fromARGB(0, 0, 0, 0),
            hintColor: const Color.fromARGB(0, 255, 255, 255),
          ),
        ),
      ),
    );
  }

  Widget _buildForegroundTextField(dynamic value, double bottomPadding) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 60.0,
        bottom: 20,
        right: 20,
        top: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          // color: NokhteColors.eggshell,
          borderRadius: BorderRadius.circular(19),
          border: _buildGradientBorder(value),
        ),
        child: MultiHitStack(
          children: [
            _buildTextField(
              onChange: store.onChange,
              textColor: const Color(0xFFFFFFFF),
              hintColor: const Color(0xC0FFFFFF),
              key: store.textFieldKey,
            ),
            _buildSubmitButton(value),
          ],
        ),
      ),
    );
  }

  GradientBoxBorder _buildGradientBorder(dynamic value) {
    return GradientBoxBorder(
      width: 1.5,
      gradient: LinearGradient(
        colors: [value.get('c1'), value.get('c2')],
        stops: [value.get('s1'), value.get('s2')],
      ),
    );
  }

  Widget _buildTextField({
    required Function(String) onChange,
    required Color textColor,
    required Color hintColor,
    Key? key,
  }) {
    return TextFormField(
      controller: store.controller,
      key: key,
      focusNode: store.focusNode,
      scrollPadding: EdgeInsets.zero,
      keyboardType: TextInputType.multiline,
      onChanged: onChange,
      maxLines: null,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: 'your ${store.blockType.name}',
        hintStyle: GoogleFonts.jost(
          color: hintColor,
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
        color: textColor,
        fontSize: 14,
      ),
    );
  }

  Widget _buildSubmitButton(dynamic value) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3.0, right: 3),
        child: GestureDetector(
          onTap: store.onSubmit,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [value.get('ic1'), value.get('ic2')],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [value.get('s1'), value.get('s2')],
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
    );
  }
}
