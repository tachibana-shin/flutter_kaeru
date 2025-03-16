import 'package:flutter/foundation.dart';

import '../foundation/computed.dart';

abstract class ReactiveNotifier<T> extends ChangeNotifier {
  T get value;

  Computed<U> select<U>(U Function(T value) getter) {
    return Computed(() => getter(value));
  }
  // final Set<VoidCallback> _listeners = {};

  // void addListener(VoidCallback cb) {
  //   _listeners.add(cb);
  // }

  // void removeListener(VoidCallback cb) {
  //   _listeners.remove(cb);
  // }

  // void notifyListeners() {
  //   for (var cb in _listeners) {
  //     cb();
  //   }
  // }

  // void dispose() {
  //   _listeners.clear();
  // }
}
