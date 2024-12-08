// ignore_for_file: constant_identifier_names, non_constant_identifier_names

mixin StaticActiveSessionsConstants {
  final String TABLE = S_TABLE;
  final String COLLABORATOR_UIDS = S_COLLABORATOR_UIDS;
  final String CREATED_AT = S_CREATED_AT;
  final String SESSION_UID = S_SESSION_UID;
  final String LEADER_UID = S_LEADER_UID;
  final String PRESET_UID = S_PRESET_UID;
  final String GROUP_UID = S_GROUP_UID;

  final String VERSION = S_VERSION;
  final String COLLABORATOR_NAMES = S_COLLABORATOR_NAMES;

  static const String S_TABLE = "static_active_sessions";
  static const String S_COLLABORATOR_UIDS = 'collaborator_uids';
  static const String S_CREATED_AT = 'created_at';
  static const String S_SESSION_UID = 'session_uid';
  static const String S_LEADER_UID = 'leader_uid';
  static const String S_PRESET_UID = 'preset_uid';
  static const String S_GROUP_UID = 'group_uid';

  static const String S_VERSION = 'version';
  static const String S_COLLABORATOR_NAMES = 'collaborator_names';
}
