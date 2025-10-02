import 'dart:async';

import '../../../../../foundation/ref.dart';
import '../../../reactive.dart';
import 'options.dart';

/// Manages the state and lifecycle of an asynchronous request.
///
/// This controller handles the data, loading, and error states,
/// as well as provides methods to run, refresh, and cancel the request.
class RequestController<T> {
  /// The asynchronous function that fetches the data.
  final Future<T> Function() service;

  /// The options for the request.
  final RequestOptions<T> options;

  /// The fetched data. It is a [Ref] so you can watch it for changes.
  final Ref<T?> data;

  /// The error object if the request fails. It is a [Ref].
  final Ref<Object?> error;

  /// The loading state of the request. It is a [Ref].
  final Ref<bool> loading;

  Timer? _pollingTimer;
  Completer<void>? _running;

  bool _canceled = false; // ← flag cancel update

  RequestController(this.service, this.options)
      : data = ref(options.initialData),
        error = ref(null),
        loading = ref(false) {
    if (!options.manual) {
      run();
    }
    if (options.pollingInterval != null) {
      _startPolling();
    }
  }

  /// Executes the request.
  ///
  /// If the request is already running, it will not start a new one,
  /// but will return the future of the currently running request.
  Future<void> run() async {
    if (_running != null && !_running!.isCompleted) {
      // 既に実行中 (already running)
      return _running!.future;
    }
    _running = Completer<void>();
    _canceled = false;

    loading.value = true;
    error.value = null;

    int attempt = 0;
    while (true) {
      try {
        final result = await service();

        if (_canceled) break;

        data.value = result;
        options.onSuccess?.call(result);
        break;
      } catch (e) {
        if (_canceled) break;

        error.value = e;
        attempt++;
        if (attempt > options.retryCount) {
          options.onError?.call(e);
          break;
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    if (!_canceled) {
      loading.value = false;
      options.onFinally?.call();
    }
    _running?.complete();
  }

  /// Re-runs the request. Alias for [run].
  Future<void> refresh() => run();

  /// Manually updates the local data.
  ///
  /// This is useful for optimistic updates.
  ///
  /// ```dart
  /// controller.mutate(optimisticData);
  /// await controller.run();
  /// ```
  void mutate(T newValue) {
    if (!_canceled) {
      data.value = newValue;
    }
  }

  /// Cancels the request.
  ///
  /// If the request is in-flight, the success or error callbacks will not be called.
  /// Polling will also be stopped.
  void cancel() {
    _canceled = true;
    loading.value = false;
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(options.pollingInterval!, (_) {
      run();
    });
  }

  /// Cleans up the controller.
  ///
  /// This should be called when the widget is disposed.
  /// It cancels any ongoing requests and timers.
  void dispose() {
    cancel();
  }
}
