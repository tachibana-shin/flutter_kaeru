import 'package:flutter/foundation.dart';
import 'package:notifier_plus/notifier_plus.dart';
import 'package:kaeru/event_bus.dart';
import 'package:kaeru/shared/watcher.dart';

import '../shared/reactive_notifier.dart';

/// A reactive class that computes a value on demand and notifies listeners
/// when the value changes.
///
/// This class acts as both a [ReactiveNotifier] and a [Watcher], allowing it
/// to observe dependencies and recompute its value when those dependencies
/// change. The computation is only triggered when [value] is accessed.
///
/// ## Features:
/// - **Lazy Computation**: The value is computed only when accessed.
/// - **Automatic Dependency Tracking**: Recomputes when observed values change.
/// - **Efficient Updates**: Notifies listeners only if the computed value changes.
///
/// ## Example Usage:
///
/// ```dart
/// // Create reactive state variables
/// final count = Ref<int>(0);
/// final doubleCount = Computed(() => count.value * 2);
///
/// // Access computed value (triggers computation)
/// print(doubleCount.value); // Output: 0
///
/// // Update dependency
/// count.value = 5;
///
/// // Computed value updates automatically
/// print(doubleCount.value); // Output: 10
///
/// // Reactivity: Automatically recomputes when `count` changes
/// watchEffect(() {
///   print('Double count changed: ${doubleCount.value}');
/// });
/// ```
///
/// ## Notes:
/// - The computation is **cached** until dependencies change.
/// - Call `force(value)` to manually override the computed value.
class Computed<T> extends ReactiveNotifier<T> with WatcherRaw<T>, Watcher<T> {
  late T _value;

  final T Function() _getValue;

  bool _initialized = false;
  bool _updated = false;

  /// Creates a new [Computed] object that computes its value using [getValue].
  ///
  /// The computation is deferred until the [value] getter is accessed.
  Computed(this._getValue) {
    onChange = oneCallTask(() {
      _updated = false;
      _runDry();
    });
    dryRun = () => _value = _getValue();
  }

  /// Triggers computation if necessary and notifies listeners when the value changes.
  void _runDry() {
    if (_updated) return;

    _updated = true;

    late final T? oldValue;
    if (_initialized) {
      oldValue = _value;
    } else {
      oldValue = null;
      _initialized = true;
    }

    run();

    if (_initialized && oldValue != _value) notifyListeners();
  }

  /// Returns the computed value, computing it if necessary.
  ///
  /// This method also establishes a dependency link with any active watcher.
  @override
  T get value {
    getCurrentWatcher()?.addDepend(this);
    _runDry();
    return _value;
  }

  /// Adds a listener and ensures computation is performed before notifying.
  ///
  /// This guarantees that the initial computed value is available before the listener is triggered.
  @override
  void addListener(VoidCallback listener) {
    _runDry();
    super.addListener(listener);
  }

  /// Manually overrides the computed value and forces an update.
  ///
  /// This can be used to temporarily override the computed result.
  void force(T value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
  }

  /// Returns a string representation of the computed value.
  @override
  String toString() => '${describeIdentity(this)}($value)';
}
