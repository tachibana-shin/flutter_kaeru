import 'package:flutter/foundation.dart';
import 'package:notifier_plus/notifier_plus.dart';
import 'package:kaeru/event_bus.dart';

import '../shared/reactive_notifier.dart';

class ShallowComputed<T> extends ReactiveNotifier<T> {
  late final VoidCallback _onChange;

  final T Function() _value;

  /// Initializes a new [ShallowComputed] with the given initial [value].
  ///
  /// The [onChange] callback schedules a notification for changes in [value].
  ShallowComputed(this._value) {
    _onChange = oneCallTask(() => notifyListeners());
  }

  /// The current value of this [ShallowComputed].
  ///
  /// When accessed, it registers itself as a dependency for any active watcher.
  @override
  T get value {
    getCurrentWatcher()?.addDepend(this);
    return _value();
  }

  /// notifyListeners
  void notify() {
    _onChange();
  }

  /// Returns a string representation containing the runtime type and the current [value].
  @override
  String toString() => '${describeIdentity(this)}($value)';
}
