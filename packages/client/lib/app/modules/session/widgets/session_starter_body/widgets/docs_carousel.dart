import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:nokhte_backend/tables/documents.dart';

class DocsCarousel extends HookWidget {
  final List<DocumentEntity> docs;
  final Function(DocumentEntity)? onTap;
  final Function(DocumentEntity)? onDeselected;
  final double height;
  final double viewportFraction;

  const DocsCarousel({
    super.key,
    required this.docs,
    this.onTap,
    this.onDeselected,
    this.height = 128,
    this.viewportFraction = 0.28,
  });

  @override
  Widget build(BuildContext context) {
    if (docs.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Jost(
            "No collaborators",
            fontSize: 12,
            shouldCenter: true,
            softWrap: true,
          ),
        ),
      );
    }
    return CarouselSlider(
      items: List.generate(
        docs.length,
        (index) {
          return Padding(
            padding: EdgeInsets.only(top: onDeselected == null ? 0 : 8.0),
            child: DocItem(
              size: const Size(90, 128),
              fontSize: 12,
              doc: docs[index],
              onTap: () => onTap?.call(docs[index]),
              onXTap: onDeselected == null
                  ? null
                  : () => onDeselected?.call(docs[index]),
            ),
          );
        },
      ),
      options: CarouselOptions(
        padEnds: false,
        pageSnapping: false,
        viewportFraction: viewportFraction,
        height: height,
        enableInfiniteScroll: false,
      ),
    );
  }
}
