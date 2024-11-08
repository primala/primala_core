import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

void main() {
  test('All presets without preferences', () {
    final presetsRes = [
      {
        'uid': '67f1af0a-45a3-48f3-a14d-1978a104642c',
        'name': 'Collaboration',
        'tags': ['tap_to_speak', 'flexible_seating', 'multi_focal_notes'],
        'phone_type': 'solo_hybrid',
        'company_presets_preferences': []
      },
      {
        'uid': 'b3176c09-298e-4792-a9f0-0bffff0d3e87',
        'name': 'Consultation',
        'tags': ['hold_to_speak', 'strict_seating', 'mono_focal_notes'],
        'phone_type': 'group_hybrid',
        'company_presets_preferences': []
      },
      {
        'uid': '309385d6-b2b6-4cdf-97a7-e81b3719ebbe',
        'name': 'Solo',
        'tags': [
          'hold_to_speak',
          'tap_to_speak',
          'deactivated_notes',
          'multi_focal_notes'
        ],
        'phone_type': 'polymorphic_solo',
        'company_presets_preferences': []
      }
    ];

    final result = CompanyPresetsModel.fromSupabase(presetsRes);
    // print('result: $result');
    expect(result.uids.length, 3);
    expect(
        result.uids,
        containsAll([
          '67f1af0a-45a3-48f3-a14d-1978a104642c',
          'b3176c09-298e-4792-a9f0-0bffff0d3e87',
          '309385d6-b2b6-4cdf-97a7-e81b3719ebbe',
        ]));

    expect(
        result.tags[0],
        containsAll([
          SessionTags.tapToSpeak,
          SessionTags.flexibleSeating,
          SessionTags.multiFocalNotes,
        ]));
    expect(
        result.tags[1],
        containsAll([
          SessionTags.holdToSpeak,
          SessionTags.strictSeating,
          SessionTags.monoFocalNotes,
        ]));
    expect(
        result.tags[2],
        containsAll([
          SessionTags.holdToSpeak,
          SessionTags.tapToSpeak,
          SessionTags.deactivatedNotes,
          SessionTags.multiFocalNotes,
        ]));

    expect(result.presets[2], PresetTypes.solo);
    expect(result.screenTypes[2], SessionScreenTypes.polymorphicSolo);
  });

  test('All presets with a preference for Solo session', () {
    final presetsRes = [
      {
        'uid': '67f1af0a-45a3-48f3-a14d-1978a104642c',
        'name': 'Collaboration',
        'tags': ['tap_to_speak', 'flexible_seating', 'multi_focal_notes'],
        'phone_type': 'solo_hybrid',
        'company_presets_preferences': []
      },
      {
        'uid': 'b3176c09-298e-4792-a9f0-0bffff0d3e87',
        'name': 'Consultation',
        'tags': ['hold_to_speak', 'strict_seating', 'mono_focal_notes'],
        'phone_type': 'group_hybrid',
        'company_presets_preferences': []
      },
      {
        'uid': '309385d6-b2b6-4cdf-97a7-e81b3719ebbe',
        'name': 'Solo',
        'tags': [
          'hold_to_speak',
          'tap_to_speak',
          'deactivated_notes',
          'multi_focal_notes'
        ],
        'phone_type': 'polymorphic_solo',
        'company_presets_preferences': [
          {
            'uid': '1a59e5b2-143c-461a-95c8-63eaf715f88c',
            'tags': ['tap_to_speak', 'multi_focal_notes'],
            'owner_uid': '56a5dd62-7d05-4587-a2b2-00adbddc1a70',
            'company_preset': '309385d6-b2b6-4cdf-97a7-e81b3719ebbe'
          }
        ]
      }
    ];

    final result = CompanyPresetsModel.fromSupabase(presetsRes);
    expect(result.uids.length, 3);
    expect(
        result.uids,
        containsAll([
          '67f1af0a-45a3-48f3-a14d-1978a104642c',
          'b3176c09-298e-4792-a9f0-0bffff0d3e87',
          '309385d6-b2b6-4cdf-97a7-e81b3719ebbe',
        ]));

    expect(
        result.tags[2],
        containsAll([
          SessionTags.tapToSpeak,
          SessionTags.multiFocalNotes,
        ]));
    final userPreferenceTags = <SessionTags>[];
    for (var section in result.articles[2].articleSections) {
      userPreferenceTags.add(section.tag);
    }

    expect(userPreferenceTags, [
      SessionTags.tapToSpeak,
      SessionTags.multiFocalNotes,
    ]);
    expect(result.screenTypes[2], SessionScreenTypes.polymorphicSolo);
  });
}
