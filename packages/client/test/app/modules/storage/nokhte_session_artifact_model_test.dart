import 'package:flutter_test/flutter_test.dart';
import 'package:nokhte/app/modules/storage/storage.dart';

void main() {
  const userUID = "user-uid";

  test('Case 1: Single Solo Session, Single Collaborator Row', () {
    final nokhteSessionRes = [
      {
        "session_timestamp": "2024-11-07T12:53:20.087602+00:00",
        "collaborator_uids": [userUID],
        "content": ["Solo session content"],
        "aliases": [''],
        "session_uid": "session-uid-1"
      }
    ];

    final collaboratorRowsRes = [
      {
        "uid": userUID,
        "first_name": "UserFirstName",
        "last_name": "UserLastName",
        "authorized_viewers": [],
        "preferred_preset": "preset-uid"
      }
    ];

    final results = NokhteSessionArtifactModel.fromSupabase(
      nokhteSessionRes: nokhteSessionRes,
      collaboratorRowsRes: collaboratorRowsRes,
      userUID: userUID,
    );
    expect(results.length, 1);
    expect(results[0].title, 'Solo Session');
    expect(results[0].content, ["Solo session content"]);
  });

  test(
      'Case 2: Three Solo Sessions, One Group Session, Single Collaborator Row',
      () {
    final nokhteSessionRes = [
      {
        "session_timestamp": "2024-11-07T12:50:52.843207+00:00",
        "collaborator_uids": [userUID],
        "content": ["Solo content 1"],
        "aliases": [''],
        "session_uid": "session-uid-2"
      },
      {
        "session_timestamp": "2024-11-07T12:51:49.264352+00:00",
        "collaborator_uids": [userUID],
        "content": ["Solo content 2"],
        "aliases": [''],
        "session_uid": "session-uid-3"
      },
      {
        "session_timestamp": "2024-11-07T12:52:56.507498+00:00",
        "collaborator_uids": [userUID],
        "content": ["Solo content 3"],
        "aliases": [''],
        "session_uid": "session-uid-4"
      },
      {
        "session_timestamp": "2024-11-07T12:53:20.087602+00:00",
        "collaborator_uids": [userUID, "collaborator-uid"],
        "content": ["Group session content"],
        "aliases": [''],
        "session_uid": "session-uid-5"
      }
    ];

    final collaboratorRowsRes = [
      {
        "uid": userUID,
        "first_name": "UserFirstName",
        "last_name": "UserLastName",
        "authorized_viewers": [],
        "preferred_preset": "preset-uid"
      }
    ];

    final results = NokhteSessionArtifactModel.fromSupabase(
      nokhteSessionRes: nokhteSessionRes,
      collaboratorRowsRes: collaboratorRowsRes,
      userUID: userUID,
    );

    expect(results.length, 4);
    expect(results[3].title, 'Session with UserFirstName');
    expect(results[3].content, ["Group session content"]);
  });

  test(
      'Case 3: Three Solo Sessions, Two Group Sessions, Multiple Collaborator Rows',
      () {
    final nokhteSessionRes = [
      {
        "session_timestamp": "2024-11-07T12:50:52.843207+00:00",
        "collaborator_uids": [userUID],
        "content": ["Solo content 1"],
        "aliases": [''],
        "session_uid": "session-uid-6"
      },
      {
        "session_timestamp": "2024-11-07T12:51:49.264352+00:00",
        "collaborator_uids": [userUID],
        "content": ["Solo content 2"],
        "aliases": [''],
        "session_uid": "session-uid-7"
      },
      {
        "session_timestamp": "2024-11-07T12:52:56.507498+00:00",
        "collaborator_uids": [userUID],
        "content": ["Solo content 3"],
        "aliases": [''],
        "session_uid": "session-uid-8"
      },
      {
        "session_timestamp": "2024-11-07T12:53:20.087602+00:00",
        "collaborator_uids": [userUID, "collaborator-uid-1"],
        "content": ["Group session 1 content"],
        "aliases": ["Alias for group session 1", ''],
        "session_uid": "session-uid-9"
      },
      {
        "session_timestamp": "2024-11-07T12:54:15.093204+00:00",
        "collaborator_uids": [userUID, "collaborator-uid-2"],
        "content": ["Group session 2 content"],
        "aliases": ["Alias for group session 2", ''],
        "session_uid": "session-uid-10"
      }
    ];

    final collaboratorRowsRes = [
      {
        "uid": userUID,
        "first_name": "UserFirstName",
        "last_name": "UserLastName",
        "authorized_viewers": [],
        "preferred_preset": "preset-uid"
      },
      {
        "uid": "collaborator-uid-1",
        "first_name": "Collaborator1",
        "last_name": "LastName1",
        "authorized_viewers": [],
        "preferred_preset": "preset-uid-1"
      },
      {
        "uid": "collaborator-uid-2",
        "first_name": "Collaborator2",
        "last_name": "LastName2",
        "authorized_viewers": [],
        "preferred_preset": "preset-uid-2"
      }
    ];

    final results = NokhteSessionArtifactModel.fromSupabase(
      nokhteSessionRes: nokhteSessionRes,
      collaboratorRowsRes: collaboratorRowsRes,
      userUID: userUID,
    );

    expect(results.length, 5);
    expect(results[3].title, 'Alias for group session 1');
    expect(results[3].content, ["Group session 1 content"]);
    expect(results[4].title, 'Alias for group session 2');
    expect(results[4].content, ["Group session 2 content"]);
  });
}
