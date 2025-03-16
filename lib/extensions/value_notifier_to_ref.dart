import 'package:flutter/foundation.dart';

import '../foundation/ref.dart';

final _weakRefStore = Expando<Ref<dynamic>>();

extension ValueNotifierToRef<T> on ValueNotifier<T> {
  Ref<T> toRef() {
    if (_weakRefStore[this] != null) return _weakRefStore[this]! as Ref<T>;

    final ref = Ref<T>(value);
    _weakRefStore[this] = ref;
    addListener(() => ref.value = value);

    return ref;
  }
}
