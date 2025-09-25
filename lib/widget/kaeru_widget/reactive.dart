import 'package:flutter/foundation.dart';
import 'package:kaeru/kaeru.dart';

import 'kaeru_widget.dart';

KaeruMixin get _kaeruContext {
  final ctx = useKaeruContext();
  assert(ctx != null, 'Reactivity must be used within a KaeruMixin');

  return ctx!;
}

/// Creates a reactive [Ref] with the given initial [value].
Ref<T> ref<T>(T initialValue) => _kaeruContext.ref(initialValue);

/// Creates a reactive [Computed] with the provided [getter] function.
Computed<T> computed<T>(T Function() compute) =>
    _kaeruContext.computed(compute);

/// Creates an instance of [AsyncComputed] with the given async function.
AsyncComputed<T> asyncComputed<T>(Future<T> Function() compute) =>
    _kaeruContext.asyncComputed(compute);

/// Sets up a reactive effect triggered by [callback].
VoidCallback watchEffect(VoidCallback effect) =>
    _kaeruContext.watchEffect(effect);

/// Sets up a watcher on the given [source] and triggers the [callback] when any
/// of the [Listenable] objects in the source change.
VoidCallback watch(Iterable<Listenable?> source, VoidCallback callback,
        {bool immediate = false}) =>
    _kaeruContext.watch(source, callback, immediate: immediate);