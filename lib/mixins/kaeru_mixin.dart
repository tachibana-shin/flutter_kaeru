import 'package:flutter/widgets.dart';

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
  Ref<U> ref<U>(U value) => _autoDispose(Ref(value));

  /// Creates a reactive [Computed] with the provided [getter] function.
  /// The value is recomputed only when dependencies change and is guaranteed
  /// to notify listeners when it is updated.
  Computed<U> computed<U>(U Function() getter) =>
      _autoDispose(Computed(getter));

  ///
  /// A mixin that extends [State] to provide reactive references and computed values.
  ///
  /// Includes methods to create reactive [Ref] objects, define [Computed] values
  /// that auto-update, and handle async computations via [AsyncComputed].
  ///
  AsyncComputed<U> asyncComputed<U>(final Future<U> Function() getValue,
          {U? defaultValue,
          void Function(dynamic)? onError,
          immediate = false}) =>
      _autoDispose(AsyncComputed<U>(getValue,
          defaultValue: defaultValue, onError: onError, immediate: immediate));

  VoidCallback watchEffect(VoidCallback callback) =>
      _autoDisposeFn(watchEffect(callback));

  VoidCallback watch(Iterable<Listenable?> source, VoidCallback callback,
          {bool immediate = false}) =>
      _autoDisposeFn(watch(source, callback, immediate: immediate));
}
