import 'package:flutter/foundation.dart';
import 'package:kaeru/kaeru.dart';

// KaeruMixin get _kaeruContext {
//   final ctx = useKaeruContext();
//   assert(ctx != null, 'Reactivity must be used within a KaeruMixin');

//   return ctx!;
// }

/// Creates a reactive [Ref] with the given initial [value].
Ref<T> ref<T>(T initialValue) =>
    (useKaeruContext()?.ref ?? Ref.new)(initialValue);

/// Creates a reactive [Computed] with the provided [getter] function.
Computed<T> computed<T>(T Function() compute) =>
    (useKaeruContext()?.computed ?? Computed.new)(compute);

/// Creates an instance of [AsyncComputed] with the given async function.
AsyncComputed<T> asyncComputed<T>(
  Future<T> Function() compute, {
  T? defaultValue,
  T? Function()? beforeUpdate,
  bool notifyBeforeUpdate = true,
  void Function(dynamic)? onError,
  bool immediate = false,
}) => (useKaeruContext()?.asyncComputed ?? AsyncComputed.new)(
  compute,
  defaultValue: defaultValue,
  beforeUpdate: beforeUpdate,
  notifyBeforeUpdate: notifyBeforeUpdate,
  onError: onError,
  immediate: immediate,
);

/// Sets up a reactive effect triggered by [callback].
VoidCallback watchEffect(VoidCallback effect) =>
    (useKaeruContext()?.watchEffect ?? watchEffect$)(effect);

/// Sets up a watcher on the given [source] and triggers the [callback] when any
/// of the [Listenable] objects in the source change.
VoidCallback watch(
  Iterable<Listenable?> source,
  VoidCallback callback, {
  bool immediate = false,
}) => (useKaeruContext()?.watch ?? watch$)(
  source,
  callback,
  immediate: immediate,
);
