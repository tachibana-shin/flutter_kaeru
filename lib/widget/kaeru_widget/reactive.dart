import 'package:flutter/foundation.dart';
import 'package:kaeru/kaeru.dart';

import 'kaeru_widget.dart';

KaeruMixin get _kaeruContext {
  final ctx = useKaeruContext();
  assert(ctx != null, 'Reactivity must be used within a KaeruMixin');

  return ctx!;
}

Ref<T> ref<T>(T initialValue) => _kaeruContext.ref(initialValue);
Computed<T> computed<T>(T Function() compute) =>
    _kaeruContext.computed(compute);
AsyncComputed<T> asyncComputed<T>(Future<T> Function() compute) =>
    _kaeruContext.asyncComputed(compute);
VoidCallback watchEffect(VoidCallback effect) =>
    _kaeruContext.watchEffect(effect);
VoidCallback watch(Iterable<Listenable?> source, VoidCallback callback,
        {bool immediate = false}) =>
    _kaeruContext.watch(source, callback, immediate: immediate);
