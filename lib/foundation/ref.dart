import 'package:flutter/foundation.dart';
import 'package:notifier_plus/notifier_plus.dart';
import 'package:reactivity/event_bus.dart';

import '../shared/reactive_notifier.dart';

class Ref<T> extends ReactiveNotifier implements ValueListenable<T> {
  late final VoidCallback _onChange;

  /// Creates a [ChangeNotifier] that wraps this value.
  Ref(this._value) {
    _onChange = oneCallTask(() => notifyListeners());
  }

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  T get value {
    getCurrentWatcher()?.addDepend(this);
    return _value;
  }

  T _value;
  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    _onChange();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
