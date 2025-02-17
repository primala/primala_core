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

    return Observer(builder: (context) {
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(1),
        child: FullScreen(
          child: MultiHitStack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: MultiHitStack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    _buildIconColumn(bottomPadding),
                    _buildTextFieldContainer(bottomPadding),
                  ],
                ),
              ),
            ],
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
                  left: 10.0, bottom: bottomPadding < 100 ? 50 : 20),
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
        return MultiHitStack(
          children: [
            _buildBlurredBackground(value, bottomPadding),
            _buildForegroundTextField(value, bottomPadding),
          ],
        );
      },
    );
  }

  Widget _buildBlurredBackground(dynamic value, double bottomPadding) {
    return Padding(
      padding: EdgeInsets.only(
          left: 60.0, bottom: bottomPadding < 100 ? 50 : 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: _buildGradientBorder(value),
        ),
        child: Blur(
          blur: 10,
          blurColor: Colors.black,
          colorOpacity: .6,
          borderRadius: BorderRadius.circular(19),
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
      padding: EdgeInsets.only(
          left: 60.0, bottom: bottomPadding < 100 ? 50 : 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: _buildGradientBorder(value),
        ),
        child: MultiHitStack(
          children: [
            _buildTextField(
              onChange: store.onChange,
              textColor: const Color.fromARGB(255, 255, 255, 255),
              hintColor: const Color.fromARGB(192, 255, 255, 255),
            ),
            _buildSubmitButton(value),
          ],
        ),
      ),
    );
  }

  GradientBoxBorder _buildGradientBorder(dynamic value) {
    return GradientBoxBorder(
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
  }) {
    return TextFormField(
      controller: store.controller,
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
