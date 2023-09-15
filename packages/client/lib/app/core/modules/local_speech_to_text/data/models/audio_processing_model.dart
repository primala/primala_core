import 'package:leopard_flutter/leopard_transcript.dart';
import 'package:primala/app/core/modules/local_speech_to_text/domain/domain.dart';

class AudioProcessingModel extends AudioProcessingEntity {
  const AudioProcessingModel({required super.resultingWords});

  static AudioProcessingModel fromLeopard(List<LeopardWord> leopardRes) {
    if (leopardRes.isEmpty) {
      return const AudioProcessingModel(resultingWords: "");
    } else {
      final List<String> words = [];
      leopardRes.map((value) {
        return words.add(value.word);
      });
      final wordsStr = words.join(' ');
      return AudioProcessingModel(resultingWords: wordsStr);
    }
  }
}
