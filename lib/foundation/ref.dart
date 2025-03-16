
import 'package:flutter/foundation.dart';
import 'package:notifier_plus/notifier_plus.dart';
import 'package:reactify/event_bus.dart';

import '../shared/reactive_notifier.dart';

/// A reactive container that holds a single value of type `T`, providing
/// notifications whenever the value changes.
///
/// By implementing [ValueListenable], other parts of the application can
/// be notified when [value] is updated. The class also extends
/// [ReactiveNotifier], integrating with the reactive ecosystem.
class Ref<T> extends ReactiveNotifier implements ValueListenable<T> {
  late final VoidCallback _onChange;

  /// Initializes a new [Ref] with the given initial [value]. The [onChange]
  /// callback is defined to schedule a single notification for changes in
  /// [value].
  Ref(this._value) {
    _onChange = oneCallTask(() => notifyListeners());
  }

  /// The current value of this [Ref]. Accessing this getter also establishes
  /// a dependency for any current watcher, meaning that if [value] changes,
  /// the watcher can respond accordingly.
  @override
  T get value {
    getCurrentWatcher()?.addDepend(this);
    return _value;
  }

  T _value;

  /// Updates the current value and triggers a change notification, unless
  /// the new value is identical to the existing one.
  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    _onChange();
  }

  /// Returns a string representation containing the runtime type and the
  /// current [value]. Useful for debugging.
  @override
  String toString() => '${describeIdentity(this)}($value)';
}
