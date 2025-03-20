import 'ref.dart';

/// `Prop<T>` is a wrapper that allows accessing and updating the value of a `Ref<T>`.
///
/// This class provides a `call()` method to retrieve the current value
/// and an `emit(value)` method to update it.
///
/// ## Example Usage:
/// 
/// ```dart
/// final ref = Ref<int>(10);
/// final prop = Prop(ref);
///
/// print(prop()); // Output: 10
///
/// prop.emit(20);
/// print(prop()); // Output: 20
/// ```
///
/// - `call()` retrieves the current value.
/// - `emit(value)` updates the value.
class Prop<T> {
  /// Holds a reference to `Ref<T>` to manage state.
  final Ref<T> _ref;

  /// Creates a `Prop<T>` with a given `Ref<T>`.
  const Prop(this._ref);

  /// Retrieves the current value of `_ref`.
  T call() => _ref.value;

  /// Updates `_ref.value` with a new value and returns the updated value.
  T emit(T value) => _ref.value = value;
}
