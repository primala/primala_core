mixin SessionUtils {
  Future<T> retry<T>({
    required Future<T> Function() action,
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    bool Function(T)? shouldRetry,
  }) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      final result = await action();

      if (shouldRetry != null && !shouldRetry(result)) {
        return result;
      }

      attempt++;
      if (attempt >= maxRetries) {
        throw Exception('Operation failed after $maxRetries attempts.');
      }

      await Future.delayed(delay);
    }

    throw Exception('Unexpected retry logic flow');
  }
}
