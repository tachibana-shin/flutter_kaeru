/// Options for configuring the behavior of [useRequest].
class RequestOptions<T> {
  /// If true, the request will not be run automatically when the widget is built.
  /// You need to call `run()` manually.
  final bool manual;

  /// The initial data to use before the request has completed.
  final T? initialData;

  /// The debounce interval for the request.
  final Duration? debounceInterval;

  /// The throttle interval for the request.
  final Duration? throttleInterval;

  /// The polling interval for the request.
  /// If set, the request will be re-run periodically.
  final Duration? pollingInterval;

  /// If true, polling will continue even when the widget is not visible.
  final bool pollingWhenHidden;

  /// The delay before the loading state is set to true.
  final Duration? loadingDelay;

  /// The number of times to retry the request if it fails.
  final int retryCount;

  /// The key to use for caching the data.
  final String? cacheKey;

  /// A callback that is called when the request succeeds.
  final void Function(T data)? onSuccess;

  /// A callback that is called when the request fails.
  final void Function(Object error)? onError;

  /// A callback that is called when the request is finished (either success or error).
  final void Function()? onFinally;

  const RequestOptions({
    this.manual = false,
    this.initialData,
    this.debounceInterval,
    this.throttleInterval,
    this.pollingInterval,
    this.pollingWhenHidden = true,
    this.loadingDelay,
    this.retryCount = 0,
    this.cacheKey,
    this.onSuccess,
    this.onError,
    this.onFinally,
  });
}
