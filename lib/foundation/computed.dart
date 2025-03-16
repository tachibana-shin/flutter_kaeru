
import 'package:flutter/foundation.dart';
import 'package:notifier_plus/notifier_plus.dart';
import 'package:kaeru/event_bus.dart';
import 'package:kaeru/shared/watcher.dart';

import '../shared/reactive_notifier.dart';

/// A class that computes a value and notifies listeners when the value changes.
///
/// The value is computed on demand, i.e. when the [value] getter is called.
/// The computation is triggered by calling [run].
///
/// The `Computed` class acts as a [ReactiveNotifier], which means it has a
/// listener list and notifies listeners when the value changes.
///
/// The `Computed` class also acts as a [Watcher], which means it can be used
/// to watch other reactive objects and recompute the value when the watched
/// objects change.
///
/// The value is stored in the [_value] field and can be accessed by calling
/// the [value] getter.
///
/// The computation is stored in the [_getValue] field and can be accessed
/// by calling the [dryRun] getter.
///
/// The computation is triggered by calling [run] which is stored in the
/// [onChange] field.
///
/// The [_runDry] function is called when the value is accessed and the
/// computation needs to be triggered.
///
/// The [_updated] field is used to track whether the computation has been
/// triggered or not.
///
/// The [_initialized] field is used to track whether the value has been
/// computed before or not.
///
/// The `Computed` class also overrides the [toString] method to provide
/// a useful string representation of the object.
class Computed<T> extends ReactiveNotifier with Watcher {
  late T _value;

  final T Function() _getValue;

  bool _initialized = false;
  bool _updated = false;

  /// Creates a new [Computed] object that uses the [getValue] function 
  /// to compute its value on demand.
  Computed(this._getValue) {
    onChange = oneCallTask(() {
      _updated = false;
      _runDry();
    });
    dryRun = () => _value = _getValue();
  }

  /// Triggers the computation if it has not been performed, and if 
  /// the value is updated, notifies listeners.
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

  /// Returns the current computed value, computing it if necessary 
  /// and establishing a dependency for any watcher.
  @override
  T get value {
    getCurrentWatcher()?.addDepend(this);
    _runDry();
    return _value;
  }

  /// Returns a string representation of this `Computed` object,
  /// including its current computed value.
  @override
  String toString() => '${describeIdentity(this)}($value)';
}
