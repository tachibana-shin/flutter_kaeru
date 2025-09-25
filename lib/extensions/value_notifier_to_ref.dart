import 'package:flutter/foundation.dart';

import '../foundation/ref.dart';

final _weakRefStore = Expando<Ref<dynamic>>();

/// An extension that allows converting a [ValueNotifier] to a [Ref].
extension ValueNotifierToRef<T> on ValueNotifier<T> {
  /// Returns a [Ref] object that mirrors the current value of this [ValueNotifier].
  /// If a [Ref] object already exists for this [ValueNotifier], it is returned.
  /// Otherwise, a new [Ref] object is created, stored, and returned.
  /// The [Ref] object's value is updated whenever this [ValueNotifier]'s value changes.
  Ref<T> toRef() {
    if (_weakRefStore[this] != null) return _weakRefStore[this]! as Ref<T>;

    final ref = Ref<T>(value);
    _weakRefStore[this] = ref;
    addListener(() => ref.value = value);
    ref.addListener(() => value = ref.value);

    return ref;
  }
}