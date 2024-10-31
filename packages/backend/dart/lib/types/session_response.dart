class SessionResponse<T> {
  final T mainType;
  final int currentVersion;

  SessionResponse({
    required this.mainType,
    required this.currentVersion,
  });
}
