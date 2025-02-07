import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/documents.dart';

class DocItem extends HookWidget {
  final Function()? onTap;
  final Function()? onXTap;
  final DocumentEntity doc;
  final Size? size;
  final double fontSize;

  const DocItem({
    super.key,
    this.onTap,
    this.onXTap,
    required this.doc,
    this.fontSize = 16,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return MultiHitStack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () => onTap?.call(),
          child: Container(
            width: size?.width,
            height: size?.height,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 8,
                right: 8,
              ),
              child: Jost(
                doc.title,
                maxLines: 2,
                fontSize: fontSize,
                shouldCenter: true,
                softWrap: true,
                useEllipsis: true,
              ),
            ),
          ),
        ),
        if (onXTap != null)
          Positioned(
            top: -5,
            right: -5,
            child: Blur(
              blurColor: Colors.black,
              colorOpacity: .6,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        if (onXTap != null)
          Positioned(
            top: -5,
            right: -5,
            child: GestureDetector(
              onTap: () => onXTap?.call(),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
