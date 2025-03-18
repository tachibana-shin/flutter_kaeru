import 'package:flutter/foundation.dart';
import 'package:kaeru/event_bus.dart';

import '../composables/watch_effect.dart';
import '../shared/reactive_notifier.dart';

/// A class that computes a value asynchronously and notifies listeners when the value changes.
///
/// This class allows you to track changes in a computed value derived from asynchronous operations.
/// It automatically updates and notifies listeners whenever the underlying asynchronous operation completes.
///
/// Example usage:
/// ```dart
/// final asyncValue = AsyncComputed(() async => await fetchData(), defaultValue: 'Loading...');
/// ```
class AsyncComputed<T> extends ReactiveNotifier {
  /// The current computed value.
  late T? _value;

  /// A callback function executed before the async computation begins.
  /// It can return an optional value that updates `_value` before the async process completes.
  final T? Function()? beforeUpdate;

  /// Determines whether listeners should be notified before the async update completes.
  final bool notifyBeforeUpdate;

  /// A callback triggered when an error occurs during computation.
  final void Function(dynamic error)? onError;

  /// The function responsible for asynchronously computing the value.
  final Future<T> Function() _getValue;

  /// Flag to track whether the computation has been initialized.
  bool _initialized = false;

  /// A function to cancel the current computation if needed.
  VoidCallback? _cancel;

  /// Creates an instance of [AsyncComputed] with the given async function.
  ///
  /// - [_getValue]: The function that fetches the computed value asynchronously.
  /// - [defaultValue]: A default value before the async computation completes.
  /// - [beforeUpdate]: A function to set a temporary value before computation.
  /// - [notifyBeforeUpdate]: If true, notifies listeners when [beforeUpdate] sets a new value.
  /// - [onError]: Callback function for handling errors during async computation.
  /// - [immediate]: If true, starts the async computation immediately upon creation.
  AsyncComputed(this._getValue,
      {T? defaultValue,
      this.beforeUpdate,
      this.notifyBeforeUpdate = true,
      this.onError,
      immediate = false}) {
    _value = defaultValue;
    if (immediate) _runDry();
  }

  /// Initiates the async computation process if it has not been started yet.
  void _runDry() {
    if (_initialized) return;
    _initialized = true;

    int currentId = -1;
    _cancel = watchEffect(() async {
      final id = ++currentId;
      try {
        if (beforeUpdate != null) {
          final value = beforeUpdate!();
          if (_value != value) {
            _value = value;
            if (notifyBeforeUpdate) notifyListeners();
          }
        }

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

  /// Returns the current computed value, ensuring the async computation starts when accessed.
  @override
  T? get value {
    getCurrentWatcher()?.addDepend(this);
    _runDry();
    return _value;
  }

  /// Adds a listener to track changes in the computed value.
  @override
  /// Adds a listener to be notified when the computed value changes.
  ///
  /// The computation is triggered before adding the listener,
  /// so that the listener can be notified of the initial value.
  ///
  /// Parameters:
  ///   listener - The callback function to be notified when the value changes.
  ///
  /// Returns:
  ///   None
  void addListener(VoidCallback listener) {
    _runDry();
    super.addListener(listener);
  }

  /// Forces the computed value to the given [value], notifying listeners if the value changes.
  /// 
  /// - [value]: The new value to be set.
  /// 
  /// Returns nothing.
  void force(T? value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
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
