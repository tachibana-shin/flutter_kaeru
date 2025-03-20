import 'package:flutter/foundation.dart';
import 'package:notifier_plus/notifier_plus.dart';
import 'package:kaeru/event_bus.dart';

import '../shared/reactive_notifier.dart';

/// A reactive container that holds a single value of type `T` and provides
/// notifications whenever the value changes.
///
/// This class implements [ValueListenable] to notify listeners when the [value] updates.
/// It also extends [ReactiveNotifier] to integrate with the reactive ecosystem.
///
/// ## Example Usage:
/// 
/// ```dart
/// // Create a reactive reference with an initial value
/// final count = Ref<int>(0);
///
/// // Listen for changes using a ValueListenableBuilder
/// ValueListenableBuilder<int>(
///   valueListenable: count,
///   builder: (context, value, child) {
///     return Text('Current Count: $value');
///   },
/// );
///
/// // Update the value and trigger notifications
/// count.value += 1; // UI updates automatically
///
/// // Reactivity: A dependent function can automatically respond to changes
/// watchEffect(() {
///   print('Count changed: ${count.value}');
/// });
/// ```
///
/// ### Features:
/// - **Reactive State**: When `value` is accessed, it registers dependencies.
/// - **Efficient Updates**: Notifies listeners only if the value actually changes.
/// - **Seamless Integration**: Works with `watchEffect()` and Flutter's `ValueListenable`.
class Ref<T> extends ReactiveNotifier implements ValueListenable<T> {
  late final VoidCallback _onChange;

  /// Initializes a new [Ref] with the given initial [value].
  ///
  /// The [onChange] callback schedules a notification for changes in [value].
  Ref(this._value) {
    _onChange = oneCallTask(() => notifyListeners());
  }

  /// The current value of this [Ref]. 
  ///
  /// When accessed, it registers itself as a dependency for any active watcher.
  @override
  T get value {
    getCurrentWatcher()?.addDepend(this);
    return _value;
  }

  T _value;

  /// Updates the current value and triggers a notification.
  ///
  /// If the new value is the same as the current value, no notification is sent.
  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    _onChange();
  }

  /// Returns a string representation containing the runtime type and the current [value].
  @override
  String toString() => '${describeIdentity(this)}($value)';
}
