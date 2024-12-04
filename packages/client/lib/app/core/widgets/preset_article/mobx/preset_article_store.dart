// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/seconds.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'preset_article_store.g.dart';

class PresetArticleStore = _PresetArticleStoreBase with _$PresetArticleStore;

abstract class _PresetArticleStoreBase extends BaseWidgetStore with Store {
  final NokhteBlurStore nokhteBlur;
  _PresetArticleStoreBase({
    required this.nokhteBlur,
  }) {
    setWidgetVisibility(false);
  }
  late BuildContext buildContext;
  late AnimationController controller;

  @action
  constructor(context, controller) {
    if (tapCount == 0) {
      buildContext = context;
      this.controller = controller;
      tapCount++;
    }
  }

  @observable
  CompanyPresetsEntity preset = CompanyPresetsEntity.initial();

  @observable
  ObservableList<ArticleSection> articleSections = ObservableList();

  @observable
  bool showPreview = false;

  @observable
  bool renderPreview = false;

  @observable
  bool hasAdjustedSessionPreferences = false;

  @observable
  int activeIndex = 0;

  @observable
  double currentPosition = 0.0;

  @action
  setCurrentPosition(double position) => currentPosition = position;

  @action
  setRenderPreview(bool value) => renderPreview = value;

  @action
  reset() {
    currentPosition = 0.0;
    hasAdjustedSessionPreferences = false;
  }

  @action
  setPreset(
    CompanyPresetsEntity entity, {
    int activeIndex = 0,
  }) {
    preset = entity;
    this.activeIndex = activeIndex;
    articleSections = ObservableList.of(article.articleSections);
  }

  @action
  setShowPreview(bool value) => showPreview = value;

  @action
  onTap() {
    if (showPreview) {
      tapCount++;
    }
  }

  @action
  onOptionToggle({
    required SessionTags newTag,
    required SessionTags pastTag,
  }) {
    if (articleSectionsTags.contains(pastTag)) {
      hasAdjustedSessionPreferences = true;
      final indexToChange = articleSectionsTags.indexOf(pastTag);
      articleSectionsTags[indexToChange] = newTag;
      preset.tags[activeIndex] = articleSectionsTags;
      articleSections = ObservableList.of(ArticleSection.fromExistingEntity(
        preset.presets[activeIndex],
        preset.tags[activeIndex],
        preset.articles[activeIndex],
      ));
    }
  }

  @action
  showBottomSheet(
    CompanyPresetsEntity preset, {
    int activeIndex = 0,
    Function? onOpen,
    Function? onClose,
  }) async {
    setPreset(preset, activeIndex: activeIndex);
    if (!showWidget) {
      setWidgetVisibility(true);
      nokhteBlur.init(
        end: Seconds.get(0, milli: 200),
      );
      showModalBottomSheet(
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(36),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.black.withOpacity(.2),
        context: buildContext,
        builder: (context) {
          return Observer(builder: (context) {
            return ModalBackdrop(
              options: options,
              articleSectionsTags: articleSectionsTags,
              entity: preset,
              activeIndex: activeIndex,
              currentPosition: currentPosition,
              currentTag: currentTag,
              articleSections: articleSections,
              currentInstructionsHeader: currentInstructionsHeader,
              currentInstruction: currentInstruction,
              currentJustification: currentJustification,
              powerUpInfo: powerUpInfo,
              onScrolled: setCurrentPosition,
              onToggle: onOptionToggle,
            );
          });
        },
      ).whenComplete(() {
        nokhteBlur.reverse();
        Timer(Seconds.get(0), () async {
          await onClose?.call();
          reset();
          setWidgetVisibility(false);
        });
      });
      await onOpen?.call();
    }
  }

  ArticleSection _getCurrentSection() {
    if (currentPosition.isLessThanOrEqualTo(.5)) {
      return articleSections[0];
    } else if (currentPosition.isGreaterThan(.5) &&
        currentPosition.isLessThanOrEqualTo(1.5)) {
      return articleSections[1];
    } else if (currentPosition.isGreaterThan(1.5)) {
      return articleSections[2];
    }
    return ArticleSection.initial();
  }

  @computed
  SessionTags get currentTag {
    if (articleSections.isNotEmpty) {
      final section = _getCurrentSection();
      return section.tag;
    } else {
      return SessionTags.none;
    }
  }

  @computed
  List<String> get currentInstruction {
    if (articleSections.isNotEmpty) {
      final section = _getCurrentSection();
      return section.articleInstructions;
    } else {
      return [];
    }
  }

  @computed
  List<String> get currentJustification {
    if (articleSections.isNotEmpty) {
      final section = _getCurrentSection();
      return section.articleJustifications;
    } else {
      return [];
    }
  }

  @computed
  PowerupInfo get powerUpInfo {
    if (articleSections.isNotEmpty) {
      final section = _getCurrentSection();
      return section.powerup;
    } else {
      return PowerupInfo.initial();
    }
  }

  @computed
  String get currentInstructionsHeader {
    if (articleSections.isNotEmpty) {
      final section = _getCurrentSection();
      return section.sectionHeader;
    } else {
      return '';
    }
  }

  @computed
  PresetArticleEntity get article => preset.articles.isEmpty
      ? PresetArticleEntity.initial()
      : preset.articles[activeIndex];

  @computed
  List<ArticleOptions> get options => article.options;

  @computed
  List<SessionTags> get allTheSessionTags =>
      articleSectionsTags.isNotEmpty ? [] : preset.tags[activeIndex];

  @computed
  List<SessionTags> get articleSectionsTags {
    final temp = <SessionTags>[];
    for (var section in articleSections) {
      temp.add(section.tag);
    }
    return temp;
  }
}
