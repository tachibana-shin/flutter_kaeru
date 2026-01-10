import 'package:flutter/widgets.dart';

import '../composables/watch.dart';
import '../composables/watch_effect.dart';
import '../foundation/async_computed.dart';
import '../foundation/computed.dart';
import '../foundation/ref.dart';

/// A mixin for `State` classes, providing helper methods to create reactive
/// values and computations.
///
/// This mixin defines two methods: [ref] and [computed].  Use [ref] to
/// create a reactive reference that notifies listeners of changes, and
/// use [computed] to define a lazy-evaluated value that automatically
/// updates whenever its dependencies change.
mixin KaeruMixin<T extends StatefulWidget> on State<T> {
  final _notifiersStore = <ChangeNotifier>{};
  final _disposesStore = <VoidCallback>{};
  // ignore: avoid_shadowing_type_parameters
  T _autoDispose<T extends ChangeNotifier>(T notifier) {
    _notifiersStore.add(notifier);
    return notifier;
  }

  VoidCallback _autoDisposeFn(VoidCallback fn) {
    _disposesStore.add(fn);
    return fn;
  }

  @override
  void dispose() {
    for (var notifier in _notifiersStore) {
      notifier.dispose();
    }
    for (var fn in _disposesStore) {
      fn();
    }

    super.dispose();
  }

  /// Creates a reactive [Ref] with the given initial [value]. This can be
  /// used to store and notify changes to a mutable value over the lifetime
  /// of the widget.
  ///
  /// The [Ref] instance is automatically disposed when the widget is disposed.
  ///
  /// Example:
  ///
  /// ```dart
  /// final count = ref(0);
  ///
  /// void increment() {
  ///   count.value++;
  /// }
  /// ```
  ///
  /// See also:
  ///
  ///  * [Ref], which is a reactive reference that notifies listeners of changes.
  ///  * [Computed], which is a lazy-evaluated value that automatically updates
  ///    whenever its dependencies change.
  ///  * [AsyncComputed], which is a lazy-evaluated value that automatically updates
  ///    whenever its dependencies change, and can be used with async functions.
  ///  * [watch], which allows you to listen to changes to a list of values.
  ///  * [watchEffect], which allows you to listen to changes to a function.
  Ref<U> ref<U>(U value) => _autoDispose(Ref(value));

  /// Creates a reactive [Computed] with the provided [getter] function.
  /// The value is recomputed only when dependencies change and is guaranteed
  /// to notify listeners when it is updated.
  ///
  /// The [Computed] instance is automatically disposed when the widget is disposed.
  Computed<U> computed<U>(U Function() getter) =>
      _autoDispose(Computed(getter));

  /// Creates an instance of [AsyncComputed] with the given async function.
  ///
  /// - [_getValue]: The function that fetches the computed value asynchronously.
  /// - [defaultValue]: A default value before the async computation completes.
  /// - [beforeUpdate]: A function to set a temporary value before computation.
  /// - [notifyBeforeUpdate]: If true, notifies listeners when [beforeUpdate] sets a new value.
  /// - [onError]: Callback function for handling errors during async computation.
  /// - [immediate]: If true, starts the async computation immediately upon creation.
  ///
  /// The [AsyncComputed] instance is automatically disposed when the widget is disposed.
  AsyncComputed<U> asyncComputed<U>(final Future<U> Function() getValue,
          {U? defaultValue,
          U? Function()? beforeUpdate,
          bool notifyBeforeUpdate = true,
          void Function(dynamic error)? onError,
          bool immediate = false}) =>
      _autoDispose(AsyncComputed<U>(getValue,
          defaultValue: defaultValue,
          beforeUpdate: beforeUpdate,
          notifyBeforeUpdate: notifyBeforeUpdate,
          onError: onError,
          immediate: immediate));

  /// Sets up a reactive effect triggered by [callback] and returns a function
  /// to dispose of the effect when it’s no longer needed.
  ///
  /// The [watchEffect] instance is automatically disposed when the widget is disposed.
  VoidCallback watchEffect(VoidCallback callback) =>
      _autoDisposeFn(watchEffect$(callback));

  /// Sets up a watcher on the given [source] and triggers the [callback] when any
  /// of the [Listenable] objects in the source change. If [immediate] is true,
  /// the [callback] is triggered immediately after setting up the listener.
  ///
  /// Returns a [VoidCallback] that can be used to remove the listener when it's
  /// no longer needed.
  ///
  /// The [watch] instance is automatically disposed when the widget is disposed.
  VoidCallback watch(Iterable<Listenable?> source, VoidCallback callback,
          {bool immediate = false}) =>
      _autoDisposeFn(watch$(source, callback, immediate: immediate));
}
