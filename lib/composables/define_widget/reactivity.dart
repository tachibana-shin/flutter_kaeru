import 'package:flutter/foundation.dart';
import 'package:kaeru/composables/watch.dart';
import 'package:kaeru/composables/watch_effect.dart';
import 'package:kaeru/foundation/async_computed.dart';
import 'package:kaeru/foundation/computed.dart';
import 'package:kaeru/foundation/ref.dart';

import 'auto_dispose.dart';

/// Creates a reactive [Ref] with the given initial [value]. This can be
/// used to store and notify changes to a mutable value over the lifetime
/// of the widget.
///
/// The [Ref] instance is automatically disposed when the widget is disposed.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
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
@Deprecated(
    'Use KaeruWidget instead. This will be removed in a future version.')
Ref<U> $ref<U>(U value) => autoContextDispose(Ref(value));

/// Creates a reactive [Computed] with the provided [getter] function.
/// The value is recomputed only when dependencies change and is guaranteed
/// to notify listeners when it is updated.
///
/// The [Computed] instance is automatically disposed when the widget is disposed.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated(
    'Use KaeruWidget instead. This will be removed in a future version.')
Computed<U> $computed<U>(U Function() getter) =>
    autoContextDispose(Computed(getter));

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
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated(
    'Use KaeruWidget instead. This will be removed in a future version.')
AsyncComputed<U> $asyncComputed<U>(final Future<U> Function() getValue,
        {U? defaultValue,
        U? Function()? beforeUpdate,
        bool notifyBeforeUpdate = true,
        void Function(dynamic error)? onError,
        bool immediate = false}) =>
    autoContextDispose(AsyncComputed<U>(getValue,
        defaultValue: defaultValue,
        beforeUpdate: beforeUpdate,
        notifyBeforeUpdate: notifyBeforeUpdate,
        onError: onError,
        immediate: immediate));

/// Sets up a reactive effect triggered by [callback] and returns a function
/// to dispose of the effect when it’s no longer needed.
///
/// The [watchEffect] instance is automatically disposed when the widget is disposed.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated(
    'Use KaeruWidget instead. This will be removed in a future version.')
VoidCallback $watchEffect(VoidCallback callback) =>
    autoContextDisposeFn(watchEffect$(callback));

/// Sets up a watcher on the given [source] and triggers the [callback] when any
/// of the [Listenable] objects in the source change. If [immediate] is true,
/// the [callback] is triggered immediately after setting up the listener.
///
/// Returns a [VoidCallback] that can be used to remove the listener when it's
/// no longer needed.
///
/// The [watch] instance is automatically disposed when the widget is disposed.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated(
    'Use KaeruWidget instead. This will be removed in a future version.')
VoidCallback $watch(Iterable<Listenable?> source, VoidCallback callback,
        {bool immediate = false}) =>
    autoContextDisposeFn(watch$(source, callback, immediate: immediate));
