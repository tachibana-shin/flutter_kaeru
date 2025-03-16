import 'package:flutter/foundation.dart';
import 'package:kaeru/event_bus.dart';

import '../composables/watch_effect.dart';
import '../shared/reactive_notifier.dart';

/// A class that computes a value asynchronously and notifies listeners when the value changes.
class AsyncComputed<T> extends ReactiveNotifier {
  late T? _value;
  final void Function(dynamic error)? onError;

  final Future<T> Function() _getValue;

  bool _initialized = false;
  VoidCallback? _cancel;

  /// Creates an instance of [AsyncComputed] with the given [_getValue] function, 
  /// an optional [defaultValue], an optional [onError] callback, and an [immediate] flag.
  /// If [immediate] is true, the computation starts immediately.
  AsyncComputed(this._getValue, {T? defaultValue, this.onError, immediate = false}) {
    _value = defaultValue;
    if (immediate) _runDry();
  }

  /// Runs the computation if it has not been initialized yet.
  void _runDry() {
    if (_initialized) return;
    _initialized = true;

    int currentId = -1;
    _cancel = watchEffect(() async {
      final id = ++currentId;
      try {
        final value = await _getValue();
        if (currentId == id && _value != value) {
          _value = value;
          notifyListeners();
        }
      } catch (error) {
        onError?.call(error);
      }
    });
  }

  /// Returns the current value and starts the computation if needed.
  @override
  T? get value {
    getCurrentWatcher()?.addDepend(this);
    _runDry();
    return _value;
  }

  /// Disposes of the [AsyncComputed] instance, cancelling any ongoing computation.
  @override
  void dispose() {
    _cancel?.call();
    super.dispose();
  }

  /// Returns a string representation of the [AsyncComputed] object.
  @override
  String toString() => '${describeIdentity(this)}($value)';
}